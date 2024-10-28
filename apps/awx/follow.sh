#!/usr/bin/env bash

stern -n awx -l job-name=awx-ansible-deploy
