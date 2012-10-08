require 'test_helper'

class RtlizerTest < ActiveSupport::TestCase
  def assert_declaration_transformation(from, to)
    assert_equal(Rtlize::RTLizer.transform_declarations(from), to)
    assert_equal(Rtlize::RTLizer.transform_declarations(to), from)
  end

  def assert_no_declaration_transformation(css)
    assert_equal(Rtlize::RTLizer.transform_declarations(css), css)
  end

  def assert_transformation(from, to)
    assert_equal(Rtlize::RTLizer.transform(from), to)
    assert_equal(Rtlize::RTLizer.transform(to), from)
  end

  def assert_no_transformation(css)
    assert_equal(Rtlize::RTLizer.transform(css), css)
  end

  test "Should transform the border properties properly" do
    assert_declaration_transformation("border-left: 1px solid red;", "border-right: 1px solid red;")

    assert_declaration_transformation("border-left-color: red;",   "border-right-color: red;")
    assert_declaration_transformation("border-left-style: solid;", "border-right-style: solid;")
    assert_declaration_transformation("border-left-width: 1px;",   "border-right-width: 1px;")

    assert_declaration_transformation("border-color: #000 #111 #222 #333;",        "border-color: #000 #333 #222 #111;")
    assert_declaration_transformation("border-style: dotted solid double dashed;", "border-style: dotted dashed double solid;")
    assert_declaration_transformation("border-width: 0px 1px 2px 3px;",            "border-width: 0px 3px 2px 1px;")
  end

  test "Should transform the clear/float properties" do
    assert_declaration_transformation("clear: left;", "clear: right;")
    assert_declaration_transformation("float: left;", "float: right;")
  end

  test "Should transform the direction property" do
    assert_declaration_transformation("direction: ltr;", "direction: rtl;")
  end

  test "Should transform the left/right position properties" do
    assert_declaration_transformation("left: 1px;", "right: 1px;")
  end

  test "Should transform the margin property" do
    assert_declaration_transformation("margin: 1px 2px 3px 4px;", "margin: 1px 4px 3px 2px;")
    assert_declaration_transformation("margin-left: 1px;", "margin-right: 1px;")
  end

  test "Should transform the padding property" do
    assert_declaration_transformation("padding: 1px 2px 3px 4px;", "padding: 1px 4px 3px 2px;")
    assert_declaration_transformation("padding-left: 1px;", "padding-right: 1px;")
  end

  test "Should transform the text-align property" do
    assert_declaration_transformation("text-align: left;", "text-align: right;")
  end

  test "Should not transform CSS rules whose selector includes .rtl" do
    assert_no_transformation(".klass span.rtl #id { float: left; }")
  end

  test "Should not transform CSS marked with no-rtl" do
    assert_no_transformation(<<CSS)
/*!= begin(no-rtl) */
.klass { float: left; }
/*!= end(no-rtl) */
CSS
  end
end

