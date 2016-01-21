require "rails_helper"

RSpec.describe "movies/new" do
  before(:each) do
    assign(:movie, Movie.new)
    assign(:validator, NullValidator.instance)
  end

  it "should display a form with labels" do
    render

    expect(rendered).to match /Title/
    expect(rendered).to match /Description/
    expect(rendered).to match /Date/
    expect(rendered).to match /Add movie/
  end
end
