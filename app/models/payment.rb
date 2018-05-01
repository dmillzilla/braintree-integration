class Payment < ActiveRecord::Base
  attr_accessor :card_number, :card_cvv, :card_expires_month, :card_expires_year
  belongs_to :user

  def process_payment
    customer_creation = gateway.customer.create(
      :email => email,
      :payment_method_nonce => nonce
    )
    if customer_creation.success?
      token = result.customer.payment_methods[0].token
    else
      puts customer_creation.errors
    end

    result = gateway.transaction.sale(
      :amount => "10.00",
      :payment_method_token => token,
      :options => {
        :submit_for_settlement => true
      }
    )
    if result.success?
      transaction = result.transaction
      puts transaction.status
    else
      puts result.errors
    end
  end
end
