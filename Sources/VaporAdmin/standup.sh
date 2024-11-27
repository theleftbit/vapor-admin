##!/bin/bash
echo "${GREEN}Building app  ${NC}"
docker compose up db redis&
swift run App serve --env development

