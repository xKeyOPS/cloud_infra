#!/bin/sh

set -e
set -u

TEST_DIR=$(dirname $0)
ANSIBLE_LINT_VERSION=$(grep ansible-lint requirements.txt | cut -f 3 -d " ")

echo "Start test container"
docker run -itd --init --rm --name xkeyops/ansible-lint xkeyops/ansible-lint sleep 600

echo "Check python version"
RESULT=$(docker exec xkeyops/ansible-lint python -c 'import sys; print(sys.version_info.major)')
echo "Want:   3"
echo "Reuslt: ${RESULT}"
if [ "${RESULT}" -eq 3 ]; then
  :
else
  echo "**Failed python version check**"
  exit 1
fi

echo "Check ansible-lint version"
RESULT=$(docker exec ansible-lint ansible-lint --version)
echo "Want:   ansible-lint ${ANSIBLE_LINT_VERSION}"
echo "Reuslt: ${RESULT}"
if [ "${RESULT}" = "ansible-lint ${ANSIBLE_LINT_VERSION}" ]; then
  :
else
  echo "**Failed ansible-lint version check**"
  exit 1
fi

echo "Check simple playbook lint"
docker cp playbooks/ ansible-lint:/work
docker exec xkeyops/ansible-lint sh -c 'set -o pipefail; find ./playbooks/ -name "*.yml" | xargs -r ansible-lint -vvv --force-color'

echo "!!! The test was successful !!!"

docker stop xkeyops/ansible-lint