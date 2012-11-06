require 'spec_helper'

describe MoviesController do
  describe 'show movies controller' do
    it 'should create new movie' do
      post :create, {:id => 1}
    end
  end
end
