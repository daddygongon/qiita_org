# -*- coding: utf-8 -*-
# frozen_string_literal: true

require "test_helper"
require "qiita_org/upload"

class QiitaFileUpLoadTest < Test::Unit::TestCase
  sub_test_case "Upload" do
    test "upload figs" do
      upload = QiitaFileUpload(src)
    end
  end
end
