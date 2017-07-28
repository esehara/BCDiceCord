#!/usr/bin/env ruby -Ku
#--*-coding:utf-8-*--

$LOAD_PATH << __dir__+"/bcdice/src/"
require 'cgi'
require_relative 'bcdice/src/bcdiceCore.rb'
require_relative 'bcdice/src/configBcDice.rb'

class DiscordBCDiceMaker < BCDiceMaker
    def newBcDice
        bcdice = DiscordBCDice.new(self, @cardTrader, @diceBot, @counterInfos, @tableFileData)
        return bcdice
    end
end

class DiscordBCDice < BCDice
    attr_reader :systemlist

    def after_initialize
      @systemlist = {}
      $allGameTypes.each do |s|
        s = replace_systemName(s)
        require "diceBot/#{s}.rb"
        system_name = Module.const_get(s).new.gameName
        @systemlist[system_name] = s
      end
    end

    def setNick(nick)
        @nick_e = nick
    end

    def validSystem?(system)
        $allGameTypes.include?(system) || $allGameTypes.include?(@systemlist[system])
    end

    def validSystemlist
      @systemlist.map do |system_name, system|
        "#{system_name}: #{system}"
      end
    end

    def getHelpMessage
      @diceBot.getHelpMessage
    end

    private
    def replace_systemName(system_name)
      system_name.gsub!(/[_|!]/, "")
      system_name.gsub!(/[:|.]/, "_")
      system_name.gsub!(/&/, "And")
      case system_name
      when "GURPS"
        system_name = "Gurps"
      when "NJSLYRBATTLE"
        system_name = "NjslyrBattle"
      when "SMTKakuseihen"
        system_name = "ShinMegamiTenseiKakuseihen"
      when "TORG"
        system_name = "Torg"
      when "TORG1_5"
        system_name = "Torg1_5"
      end
      system_name
    end
end
