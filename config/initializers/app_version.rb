# frozen_string_literal: true

APP_VERSION = `git describe --always`.chomp unless defined? APP_VERSION
