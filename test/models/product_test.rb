require "test_helper"

class ProductTest < ActiveSupport::TestCase

  def new_product(image_url)
  	Product.new(title:	"My Book Title",
  			description: "yyy",
  			price:	1,
  			image_url: image_url)
  end

  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:price].any?
  	assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
  	product = Product.new(title:	"My Book Title",
  				description:	"yyy",
  				image_url:	"zzz.jpg")
  	product.price = -1
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

  	product.price = 0
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

  	product.price = 1
  	assert product.valid?
  end

  test "product title must have length of 10 or more" do
  	product = Product.new(title:	"My",
  				description:	"yyy",
  				image_url:	"zzz.jpg")
  	assert product.invalid?
  	assert_equal ["is too short (minimum is 10 characters)"], product.errors[:title]
  end

  test "product price, using custom method, must be positive" do
    product = new_product("zzz.jpg")
    assert product.valid?

  	product.price = -1
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

  	product.price = 0
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  end

  test "image url" do
  	ok = %w{ fred.gif fred.jpg fred.jpeg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more fred.gif.more }

  	ok.each do |image_url|
  		assert new_product(image_url).valid?, "#{image_url} shouldn't be invalid"
  	end

  	bad.each do |image_url|
  		assert new_product(image_url).invalid?, "#{image_url} shouldn't be valid"
  	end
  end

  test "product is not valid without a unique title" do
  	product = Product.new(title:	products(:ruby).title,
  				description:	"yyy",
  				price:		1,
  				image_url:	"fred.gif")

  	assert product.invalid?
  	assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - I18n" do
    product = Product.new(title:	products(:ruby).title,
          description:	"yyy",
          price:		1,
          image_url:	"fred.gif")

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

end
