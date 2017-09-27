require 'rails_helper'

describe 'Products API' do
  let(:company) do
    FactoryGirl.create :company, owner: user
  end

  let(:user) do
    FactoryGirl.create :user, password: 'password'
  end

  before do
    sign_in_as!(user)
  end

  context '#index' do
    let(:api_call) do
      get "/api/v1/companies/#{company.id}/products"
    end

    let(:product) do
      FactoryGirl.create :product, company: company
    end

    let(:color_option) do
      FactoryGirl.create :products_option,
                         product: product,
                         option_name: 'color'
    end

    let(:size_option) do
      FactoryGirl.create :products_option,
                         product: product,
                         option_name: 'size'
    end

    let!(:blue_value) do
      FactoryGirl.create :products_option_value,
                         option: color_option,
                         option_value: 'blue'
    end

    let!(:red_value) do
      FactoryGirl.create :products_option_value,
                         option: color_option,
                         option_value: 'red'
    end

    let!(:medium_value) do
      FactoryGirl.create :products_option_value,
                         option: size_option,
                         option_value: 'medium'
    end

    let!(:large_value) do
      FactoryGirl.create :products_option_value,
                         option: size_option,
                         option_value: 'large'
    end

    let(:expected_response) do
      [
        {
          id: product.id,
          title: product.title,
          description: product.description,
          image_url: product.image_url,
          price: Money.new(product.price_cents, 'USD').format(symbol: true),
          options_attributes: [
            {
              id: color_option.id,
              option_name: 'color',
              option_values_attributes: [
                {
                  id: blue_value.id,
                  option_value: 'blue'
                },
                {
                  id: red_value.id,
                  option_value: 'red'
                }
              ]
            },
            {
              id: size_option.id,
              option_name: 'size',
              option_values_attributes: [
                {
                  id: medium_value.id,
                  option_value: 'medium'
                },
                {
                  id: large_value.id,
                  option_value: 'large'
                }
              ]
            }
          ],
          variants: [
            {
              variant_values: [
                { id: 1, option_value: { id: 1, option_value: 'blue' } },
                { id: 3, option_value: { id: 3, option_value: 'medium' } }
              ]
            },
            {
              variant_values: [
                { id: 2, option_value: { id: 2, option_value: 'red' } },
                { id: 4, option_value: { id: 3, option_value: 'medium' } }
              ]
            },
            {
              variant_values: [
                { id: 5, option_value: { id: 4, option_value: 'large' } },
                { id: 6, option_value: { id: 1, option_value: 'blue' } }
              ]
            },
            {
              variant_values: [
                { id: 7, option_value: { id: 4, option_value: 'large' } },
                { id: 8, option_value: { id: 2, option_value: 'red' } }
              ]
            }
          ]
        }
      ]
    end

    it 'should return the expected response' do
      api_call

      expect(json_response).to eq expected_response
    end
  end

  context '#create' do
    let(:api_call) do
      post "/api/v1/companies/#{company.id}/products", params
    end

    let(:params) do
      {
        params: {
          product: {
            title: 'Product Title',
            description: 'Product Description',
            image_url: 'www.myimage.com',
            price_cents: 10000,
            options_attributes: [
              {
                option_name: 'color',
                option_values_attributes: [
                  { option_value: 'blue' },
                  { option_value: 'red' }
                ]
              },
              {
                option_name: 'size',
                option_values_attributes: [
                  { option_value: 'medium' },
                  { option_value: 'large' }
                ]
              }
            ]
          }
        }
      }
    end

    it 'should successfully create a product' do
      expect { api_call }.to change { Product.count }.by(1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response[:id]).to_not be_nil
    end
  end

  context '#update' do
    let(:api_call) do
      put "/api/v1/companies/#{company.id}/products/#{product.id}", params
    end

    let(:product) do
      FactoryGirl.create :product, company: company
    end

    let(:color_option) do
      FactoryGirl.create :products_option,
                         product: product,
                         option_name: 'color'
    end

    let(:size_option) do
      FactoryGirl.create :products_option,
                         product: product,
                         option_name: 'size'
    end

    let!(:blue_value) do
      FactoryGirl.create :products_option_value,
                         option: color_option,
                         option_value: 'blue'
    end

    let!(:red_value) do
      FactoryGirl.create :products_option_value,
                         option: color_option,
                         option_value: 'red'
    end

    let!(:medium_value) do
      FactoryGirl.create :products_option_value,
                         option: size_option,
                         option_value: 'medium'
    end

    let!(:large_value) do
      FactoryGirl.create :products_option_value,
                         option: size_option,
                         option_value: 'large'
    end

    let(:params) do
      {
        params: {
          product: {
            title: 'Product Title',
            description: 'Product Description',
            image_url: 'www.myimage.com',
            price_cents: 10000,
            options_attributes: [
              {
                id: color_option.id,
                option_name: 'color',
                option_values_attributes: [
                  {
                    id: blue_value.id,
                    option_value: 'green'
                  },
                  {
                    id: red_value.id,
                    option_value: 'gray'
                  }
                ]
              },
              {
                id: size_option.id,
                option_name: 'size',
                option_values_attributes: [
                  {
                    id: medium_value.id,
                    option_value: 'tiny'
                  },
                  {
                    id: large_value.id,
                    option_value: 'small'
                  }
                ]
              }
            ]
          }
        }
      }
    end

    it 'should return the updated product' do
      api_call

      expect(json_response[:id]).to_not be_nil
    end
  end

  context '#show' do
    let(:api_call) do
      get "/api/v1/companies/#{company.id}/products/#{product.id}"
    end

    let(:product) do
      FactoryGirl.create :product, company: company
    end

    let(:color_option) do
      FactoryGirl.create :products_option,
                         product: product,
                         option_name: 'color'
    end

    let(:size_option) do
      FactoryGirl.create :products_option,
                         product: product,
                         option_name: 'size'
    end

    let!(:blue_value) do
      FactoryGirl.create :products_option_value,
                         option: color_option,
                         option_value: 'blue'
    end

    let!(:red_value) do
      FactoryGirl.create :products_option_value,
                         option: color_option,
                         option_value: 'red'
    end

    let!(:medium_value) do
      FactoryGirl.create :products_option_value,
                         option: size_option,
                         option_value: 'medium'
    end

    let!(:large_value) do
      FactoryGirl.create :products_option_value,
                         option: size_option,
                         option_value: 'large'
    end

    let(:expected_response) do
      {
        id: product.id,
        title: product.title,
        description: product.description,
        image_url: product.image_url,
        price: Money.new(product.price_cents, 'USD').format(symbol: true)
      }
    end

    it 'should return the product details' do
      api_call

      expect(json_response[:id]).to_not be_nil
    end
  end

  context '#destroy' do
    let(:api_call) do
      delete "/api/v1/companies/#{company.id}/products/#{product.id}"
    end

    let!(:product) do
      FactoryGirl.create :product, company: company
    end

    let(:expected_response) do
      { success: true }
    end

    it 'should successfully delete the product' do
      expect { api_call }.to change { Product.count }.by(-1)
    end

    it 'should return the expected response' do
      api_call

      expect(json_response).to eq expected_response
    end
  end
end
