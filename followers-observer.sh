#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" # スクリプトがあるディレクトリのパス
FILE_NAME="${SCRIPT_DIR}/followers.json" # フォロワーリストを保存するファイル名
BACKUP_DATE_FORMAT=$(date +%Y%m%d)
BACKUP_FILE_NAME="${SCRIPT_DIR}/followers.backup.${BACKUP_DATE_FORMAT}.json"

# 引数の解析
while [ "$#" -gt 0 ]; do
  case "$1" in
    -u|--user-id)
      USER_ID="$2"
      shift 2
      ;;
    -t|--bearer-token)
      BEARER_TOKEN="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [ -z "${USER_ID}" ] || [ -z "${BEARER_TOKEN}" ]; then
  echo "Usage: $0 --user-id USER_ID --bearer-token BEARER_TOKEN"
  exit 1
fi

fetch_followers() {
  curl -s --location --request GET "https://api.twitter.com/2/users/${USER_ID}/followers?max_results=1000" --header "Authorization: Bearer ${BEARER_TOKEN}"
}

if [ ! -f "${FILE_NAME}" ]; then
  echo "No previous followers data found. Saving current followers."
  fetch_followers > "${FILE_NAME}"
  exit 0
fi

OLD_FOLLOWERS=$(cat "${FILE_NAME}")
NEW_FOLLOWERS=$(fetch_followers)

# Save old followers as a backup
cp "${FILE_NAME}" "${BACKUP_FILE_NAME}"

ADDED_FOLLOWERS=$(echo "${NEW_FOLLOWERS}" | grep -Po '"id":\K"[^"]+"' | while read -r line; do
  if ! echo "${OLD_FOLLOWERS}" | grep -q "${line}"; then
    echo "${line}"
  fi
done)

REMOVED_FOLLOWERS=$(echo "${OLD_FOLLOWERS}" | grep -Po '"id":\K"[^"]+"' | while read -r line; do
  if ! echo "${NEW_FOLLOWERS}" | grep -q "${line}"; then
    echo "${line}"
  fi
done)

if [ -z "${ADDED_FOLLOWERS}" ]; then
  echo "No new followers added."
else
  echo "Added followers:"
  for id in ${ADDED_FOLLOWERS}; do
    echo "${NEW_FOLLOWERS}" | grep -B 2 -A 1 "${id}"
  done
fi

if [ -z "${REMOVED_FOLLOWERS}" ]; then
  echo "No followers removed."
else
  echo "Removed followers:"
  for id in ${REMOVED_FOLLOWERS}; do
    echo "${OLD_FOLLOWERS}" | grep -B 2 -A 1 "${id}"
  done
fi

echo "${NEW_FOLLOWERS}" > "${FILE_NAME}"
