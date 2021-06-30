# -*- coding: utf-8 -*-
# frozen_string_literal: true

require "test_helper"
require "qiita_org/upload"

class QiitaFileUpLoadTest < Test::Unit::TestCase
  sub_test_case "Upload" do
    test "upload figs" do
      p file = File.expand_path("../../test/org_samples/upload_test.org", __FILE__)
      assert_equal(true, QiitaFileUpLoad.new(file, "private", "mac").upload)
    end
  end
end
