#!/usr/bin/ruby -Ku
require 'sequel'
require 'fileutils'

# migrate script

DBNAME = __dir__+'/database.sqlite'

unless(File.exist?(DBNAME))
    FileUtils.touch(DBNAME)
end

Sequel.sqlite(DBNAME).create_table :servers do
    Integer :server_id, :primary_key=>true
    String :system, :text=>true
end