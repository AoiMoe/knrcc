#! /bin/sh

gitcommit() {
    d="$1"
    shift
    TZ=UTC GIT_AUTHOR_DATE="$d" GIT_COMMITTER_DATE="$d" git commit "$@"
}

usage() {
    echo "$1" >&2
    echo "$0 <path_to_sources>" >&2
    exit 1
}

test x"$1" = x && usage "error: no argument"
test -e .git && usage "error: .git already exists"

src="$1"
shift

cat > .gitignore <<EOF
c/*.o
c/*.a
c/cvopt
**/*~
knrcc.sh
sync.sh
EOF

cat > README.md <<'EOF'
# K&R cc

These files are obtained from [the Unix Archive](https://www.tuhs.org/Archive/) of
[the Unix Heritage Society](https://www.tuhs.org).

## tips
use `git diff -M40%` to compare between v6 and v7.
EOF

cat > LICENSE <<'EOF'
NOTE: Original license file is placed at https://www.tuhs.org/Archive/Caldera-license.pdf.

Copyright(C) Caldera International Inc. 2001-2002. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
following conditions are met:

Redistributions of source code and documentation must retain the above copyright notice, this list of conditions and the
following disclaimer. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
and the following disclaimer in the documentation and/or other materials provided with the distribution.

All advertising materials mentioning features or use of this software must display the following acknowledgement:

This product includes software developed or owned by Caldera International, Inc.

Neither the name of Caldera International, Inc. nor the names of other contributors may be used to endorse or promote
products derived from this software without specific prior written permission.

USE OF THE SOFTWARE PROVIDED FOR UNDER THIS LICENSE BY CALDERA INTERNATIONAL, INC.
AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL CALDERA INTERNATIONAL, INC. BE LIABLE FOR
ANY DIRECT, INDIRECT INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
EOF

cat > sync.sh <<'EOF'
#! /bin/sh

usage() {
    echo "$1" >&2
    echo "$0 <repo URL>" >&2
    exit 1
}

test x"$1" = x && usage "error: no argument"

repo="$1"
shift

git remote add origin $repo
git push -f -u origin master
git push -f origin epoch v5 v6 v7
EOF
chmod +x sync.sh

git init
git config --local user.name 'dmr'
git config --local user.email 'dmr'

gitcommit '1970-01-01 00:00:00' --allow-empty --allow-empty-message -m ""

git add -f .gitignore knrcc.sh sync.sh
gitcommit '1970-01-01 00:00:00' --allow-empty --allow-empty-message -m ""

git rm --cached knrcc.sh sync.sh
gitcommit '1970-01-01 00:00:00' --allow-empty --allow-empty-message -m ""

git add README.md LICENSE
gitcommit '1970-01-01 00:00:00' --allow-empty --allow-empty-message -m ""
git tag epoch

rm -rf c cc.c
cp -r $src/v5/usr/c .
cp $src/v5/usr/source/s1/cc.c .
git add -A
gitcommit '1974-06-01 00:00:00' --message 'Fifth Edition Unix'
git tag v5

rm -rf c cc.c
cp $src/v6/s1/cc.c .
cp -r $src/v6/c .
git add -A
gitcommit '1975-05-01 00:00:00' --message 'Sixth Edition Unix'
git tag v6

rm -rf c cc.c
cp $src/v7/usr/src/cmd/cc.c .
cp -r $src/v7/usr/src/cmd/c .
git add -A
gitcommit '1979-01-01 00:00:00' --message 'Seventh Edition Unix'
git tag v7
