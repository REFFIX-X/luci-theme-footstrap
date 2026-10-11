#!/bin/sh
# What `owfeed build` left in dist/, checked against what a release has to contain.
#
# The catalogues: a .lmo is a build artefact, not a file in git, and a silently missing one makes
# every _() render its English msgid with nothing complaining. Each language ships as its own
# `luci-i18n-footstrap-<lang>`, the way luci.mk emits them, so the assertion is one catalogue per
# language package and NONE in the theme — two packages owning one path is an install apk refuses.
#
# Read out of the ipk, that container being a plain tar. The apk is not a tar at all — apk-tools 3
# packages the payload as one ADB (Alpine/OpenWrt "atom data blob") container, raw-deflate compressed
# behind an "ADBd" prefix — so a byte-for-byte parity claim between the two legs needs its own reader
# rather than "one is enough" for a format tar cannot open. apk_list() below is that reader: it
# decompresses the ADBd stream, walks the block list for the control (ADB_BLOCK_ADB) block, and reads
# the package/paths/files tree the same way `apk` itself would to answer "what does this ship" — the
# schema (package field indices, the count-prefixed slot array both objects and arrays use on disk)
# comes from apk-tools' own src/adb.h and src/apk_adb.h, and every field read here was checked
# against a real `apk mkpkg` output before being trusted (a 39-path theme .apk and a 3-path
# luci-i18n-footstrap-ru .apk, both decoding to exactly the files staged into them).
#
# THREE ZERO-BYTE .apk FILES USED TO PASS THIS WHOLE GATE, because the apk leg never opened one — it
# matched a filename pattern and stopped. apk_list() below fails loudly on anything that is not a
# real ADB package (wrong size, wrong magic, undecodable stream, no control block), which is what
# turns "the file exists" into "the file is what CI thinks it packed".
#
# Exactly one theme package per format, BY NAME. Load-bearing: anything resolving the theme by a
# loose pattern and taking head -1 mis-picks a stray asset that matches it — a per-language
# luci-i18n package did that and was installed AS the theme, reporting success (issue #6). The
# language packages are back, so the name test matters more than it did, not less: install.sh reads
# the signed manifest and matches `$2 == "luci-theme-footstrap"` exactly, and this is what keeps a
# second package from answering to that name.
set -eu
cd "$(dirname "$0")/.."

# With dist/ missing entirely (deleted, or a build that never ran), `find` below reads an empty list
# and every count compares 0 = 0 — the stray-catalogue assertion four lines down used to be the first
# thing to notice, which is the wrong failure for "nothing was built".
[ -d dist ] || { echo "check-packages: no dist/ — run tools/stage.sh && owfeed build first"; exit 1; }

# <apk> -> the paths inside it. See the header comment for what this decodes and against what it was
# checked. python3 is already a hard dependency of this repo's gates (tools/audit.py), so requiring
# it here costs nothing new.
apk_list() {
	command -v python3 >/dev/null || {
		echo "check-packages: python3 not found — needed to open a .apk (ADB) archive" >&2
		exit 1
	}
	python3 - "$1" <<'PY'
import struct, sys, zlib

path = sys.argv[1]

def fail(msg):
	sys.stderr.write("check-packages: %s\n" % msg)
	sys.exit(1)

try:
	raw = open(path, 'rb').read()
except OSError as e:
	fail("%s: %s" % (path, e))

# The ADB file header is 8 bytes: a 4-byte magic ("ADB." uncompressed, "ADBd" for the raw-deflate
# body apk mkpkg actually writes) then a 4-byte schema. A truncated or zero-byte file fails right
# here — this is the check the three zero-byte .apk files in the original defect never met.
if len(raw) < 8 or raw[:3] != b'ADB':
	fail("%s: not an APKv3 (ADB) archive — %d byte(s), no ADB header" % (path, len(raw)))

comp = raw[3:4]
if comp == b'd':
	try:
		image = zlib.decompress(raw[4:], -15)
	except zlib.error as e:
		fail("%s: the ADBd raw-deflate body will not decompress — %s" % (path, e))
elif comp == b'.':
	image = raw[4:]
else:
	fail("%s: ADB compression 'ADB%s' is not one this reader decodes (apk mkpkg has only ever "
		"written raw-deflate 'ADBd' or uncompressed 'ADB.' for this package)"
		% (path, comp.decode('latin1')))

if len(image) < 8:
	fail("%s: ADB body too short for a file header" % path)
magic, schema = struct.unpack_from('<II', image, 0)
if magic != 0x2e424441:
	fail("%s: bad ADB magic 0x%08x" % (path, magic))
if schema != 0x676b6370:		# ADB_SCHEMA_PACKAGE, "pckg"
	fail("%s: ADB schema 0x%08x is not a package ('pckg')" % (path, schema))

# Blocks: ADB_BLOCK_ADB (0) is the control blob this function reads; SIG (1) and DATA (2) carry the
# signature and the file contents, neither of which a path listing needs.
adb, off = None, 8
while off < len(image):
	if off + 4 > len(image):
		fail("%s: truncated ADB block header at byte %d" % (path, off))
	type_size = struct.unpack_from('<I', image, off)[0]
	btype, size = type_size >> 30, type_size & 0x3fffffff
	if size < 4 or off + size > len(image):
		fail("%s: ADB block at byte %d has an impossible size" % (path, off))
	if btype == 0:
		adb = image[off + 4:off + size]
	off += (size + 7) & ~7
if adb is None:
	fail("%s: no control (ADB_BLOCK_ADB) block — not a package apk can install" % path)

def u32(o):
	return struct.unpack_from('<I', adb, o)[0]

def slots(val):
	# On disk, an object and an array are the same shape: slot 0 is the entry count, and
	# field/item N (1-based) sits at slots[N]. apk-tools tags ADBI_PKG_PATHS with the OBJECT type
	# (0xe0000000) rather than ARRAY on a real `apk mkpkg` build, so this reader does not
	# distinguish the two tags — checked against a real package, not against the schema doc alone.
	o = val & 0x0fffffff
	n = u32(o)
	return [u32(o + 4 * i) for i in range(n)]

def blob(val):
	if val == 0:
		return b''
	t, o = val & 0xf0000000, val & 0x0fffffff
	if t == 0x80000000:
		n, start = adb[o], o + 1
	elif t == 0x90000000:
		n, start = struct.unpack_from('<H', adb, o)[0], o + 2
	elif t == 0xa0000000:
		n, start = struct.unpack_from('<I', adb, o)[0], o + 4
	else:
		fail("%s: expected a string, got ADB type 0x%x" % (path, t))
	return adb[start:start + n]

root = slots(struct.unpack_from('<I', adb, 4)[0])
PKG_PATHS = 2
if len(root) <= PKG_PATHS or not root[PKG_PATHS]:
	fail("%s: package control carries no paths" % path)

DI_NAME, DI_FILES, FI_NAME = 1, 3, 1
for dval in slots(root[PKG_PATHS])[1:]:
	if not dval:
		continue
	d = slots(dval)
	dname = blob(d[DI_NAME]).decode('utf-8', 'replace')
	files = slots(d[DI_FILES])[1:] if len(d) > DI_FILES and d[DI_FILES] else []
	for fval in files:
		if not fval:
			continue
		f = slots(fval)
		fname = blob(f[FI_NAME]).decode('utf-8', 'replace')
		print((dname.rstrip('/') + '/' + fname).lstrip('/'))
PY
}

# The published package set is OpenWrt 25.12/APK only.
langs=$(find luci-theme-footstrap/po -mindepth 1 -maxdepth 1 -type d ! -name templates -exec basename {} \;)
[ -n "$langs" ] || { echo "no language directory under po/ — the glob is wrong, not the build"; exit 1; }

theme_apk=$(find dist/noarch -type f -name "luci-theme-footstrap-*.apk" | head -1)
[ -n "$theme_apk" ] || { echo "no luci-theme-footstrap .apk in dist/noarch/ to open"; exit 1; }
apk_listing=$(apk_list "$theme_apk")
astray=$(printf '%s\n' "$apk_listing" | grep -c 'i18n/.*\.lmo' || true)
[ "$astray" = 0 ] || {
	echo "the theme .apk carries $astray catalogue(s) of its own; catalogues must live in language packages"
	exit 1
}

n=0
for lang in $langs; do
	f=$(find dist/noarch -type f -name "luci-i18n-footstrap-${lang}-*.apk" | head -1)
	[ -n "$f" ] || { echo "po/$lang has no luci-i18n-footstrap-$lang APK in dist/noarch/"; exit 1; }
	listing=$(apk_list "$f")
	got=$(printf '%s\n' "$listing" | grep -c "i18n/footstrap\.${lang}\.lmo\$" || true)
	[ "$got" = 1 ] || {
		echo "luci-i18n-footstrap-$lang APK carries $got catalogues named footstrap.$lang.lmo; expected exactly 1"
		exit 1
	}
	printf '%s\n' "$listing" | grep -q "etc/uci-defaults/luci-i18n-footstrap-$lang\$" || {
		echo "luci-i18n-footstrap-$lang APK does not register its language in LuCI's menu"
		exit 1
	}
	n=$((n + 1))
done
echo "$n language package(s), one catalogue each, none in the theme, OpenWrt 25.12/APK only."

find dist/noarch -mindepth 1 -type f -name '*.apk' -print
m=$(find dist/noarch -type f -name 'luci-theme-footstrap-*.apk' | wc -l | tr -d ' ')
[ "$m" = 1 ] || { echo "expected exactly 1 theme APK, got $m"; exit 1; }
i=$(find dist/noarch -type f -name 'luci-i18n-footstrap-*.apk' | wc -l | tr -d ' ')
[ "$i" = "$n" ] || { echo "expected $n language APKs, got $i"; exit 1; }
ipks=$(find dist -type f -name '*.ipk' -print)
[ -z "$ipks" ] || { echo "unexpected IPK files in an APK-only build:"; printf '%s\n' "$ipks"; exit 1; }
