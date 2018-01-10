function title {
  local blue='\033[1;34m'
  local nc='\033[0m' # No Color
  echo -e "${blue}[$(date '+%Y-%m-%d %H:%M:%S %Z')][Chef] $1${nc}"
}

