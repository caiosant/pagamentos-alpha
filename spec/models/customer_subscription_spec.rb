require 'rails_helper'

RSpec.describe CustomerSubscription, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  context '.renew_subscriptions' do
    it 'should create purchases for subscriptions in 2021-12-01' do
      date = Date.new(2021, 12, 01)
      customer_subscription_1 = customer_subscription_2 = another_customer_subscription = nil
      
      travel_to date do
        customer_subscription_1, customer_subscription_2 = create_list(
          :customer_subscription, 2
        )
      end

      travel_to date + 1.day do
        another_customer_subscription = create(:customer_subscription)
      end

      travel_to date + 1.month do
        CustomerSubscription.renew_subscriptions

        expect(Purchase.count).to eq(2)
        first_purchase = Purchase.first
        second_purchase = Purchase.second
        expect(first_purchase.customer_payment_method.token).to eq(
          customer_subscription_1.customer_payment_method.token
        )
        expect(first_purchase.product.token).to eq(customer_subscription_1.product.token)
        expect(first_purchase.cost).to eq(customer_subscription_1.cost)
        expect(first_purchase.expiration_date.day).to eq(customer_subscription_1.renovation_date)
        expect(first_purchase.company.id).to eq(customer_subscription_1.company.id)

        expect(second_purchase.customer_payment_method.token).to eq(
          customer_subscription_2.customer_payment_method.token
        )
        expect(second_purchase.product.token).to eq(customer_subscription_2.product.token)
        expect(second_purchase.cost).to eq(customer_subscription_2.cost)
        expect(second_purchase.expiration_date.day).to eq(customer_subscription_2.renovation_date)
        expect(second_purchase.company.id).to eq(customer_subscription_2.company.id)
      end
    end
    
    it 'should not create purchase at same day subscription is created' do
      another_customer_subscription = customer_subscription = nil
      date = Date.new(2021, 12, 01)

      travel_to date do
        another_customer_subscription = create(:customer_subscription)
      end

      travel_to date + 1.month do
        customer_subscription = create(:customer_subscription)

        CustomerSubscription.renew_subscriptions

        expect(Purchase.count).to eq(1)
        first_purchase = Purchase.first
        expect(first_purchase.customer_payment_method.token).to eq(
          another_customer_subscription.customer_payment_method.token
        )
        expect(first_purchase.product.token).to eq(another_customer_subscription.product.token)
        expect(first_purchase.customer_payment_method.token).not_to eq(
          customer_subscription.customer_payment_method.token
        )
        expect(first_purchase.product.token).not_to eq(customer_subscription.product.token)
      end
    end

    it 'should not create purchases for canceled subscriptions'
    
    it 'should create purchases for subscriptions not renewed in the right day'
  end

  # PoF, PULAR PRA NÃO ATRAPALHAR O FLUXO NORMAL DOS TESTES
  context 'scheduler' do
    xit 'should automatically create purchases' do
      customer_subscription_1 = customer_subscription_2 = nil
      
      travel_to Date.new(2021, 12, 01) do
        customer_subscription_1, customer_subscription_2 = create_list(
          :customer_subscription, 2
        )
      end

      travel_to Date.new(2022, 01, 01) do
        # isso espera o rufus-scheduler rodar antes que o teste acabe
        sleep 1

        expect(Purchase.count).to eq(2)
        first_purchase = Purchase.first
        second_purchase = Purchase.second
        expect(first_purchase.customer_payment_method.token).to eq(
          customer_subscription_1.customer_payment_method.token
        )
        expect(first_purchase.product.token).to eq(customer_subscription_1.product.token)
        expect(first_purchase.cost).to eq(customer_subscription_1.cost)
        expect(first_purchase.expiration_date.day).to eq(customer_subscription_1.renovation_date)
        expect(first_purchase.company.id).to eq(customer_subscription_1.company.id)

        expect(second_purchase.customer_payment_method.token).to eq(
          customer_subscription_2.customer_payment_method.token
        )
        expect(second_purchase.product.token).to eq(customer_subscription_2.product.token)
        expect(second_purchase.cost).to eq(customer_subscription_2.cost)
        expect(second_purchase.expiration_date.day).to eq(customer_subscription_2.renovation_date)
        expect(second_purchase.company.id).to eq(customer_subscription_2.company.id)
      end

      travel_to Date.new(2022, 02, 01) do
        sleep 1
        expect(Purchase.count).to eq(4)
      end
    end
  end
end
