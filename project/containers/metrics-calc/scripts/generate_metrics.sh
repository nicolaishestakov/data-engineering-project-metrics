echo "processing snapshot $1"

DIR=${SNAPSHOTS_DIR}/$1

if [ -d "$DIR" ]; then
  echo "$DIR does exist."
else
  echo "ERROR: $DIR not found"
  exit 1
fi

set -e

cd "$DIR"

metrix++ collect --ll=ERROR --std.code.lines.code --std.code.complexity.cyclomatic

metrix++ export --ll=ERROR > "$1.csv"

mkdir ${METRICS_DIR} -p && cp "$1.csv" "${METRICS_DIR}/$1.csv"