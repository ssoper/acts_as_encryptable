require File.dirname(__FILE__) + '/../test_helper'

class BaseTest < Test::Unit::TestCase
  
  class CreditCard < ActiveRecord::Base
    attr_accessor :name_on_card, :number, :expiration
    acts_as_encryptable :name_on_card, :number, :expiration
  end

  class Person < ActiveRecord::Base
    attr_accessor :first_name, :last_name, :ssn
    acts_as_encryptable :first_name, :last_name, :ssn, :column => 'important_data'
  end

  def setup
    @connection = establish_connection
  end
  
  def test_a_credit_card
    card = CreditCard.new(valid_credit_card)
    assert card.save
  end
  
  def test_data_is_encrypted
    test_a_credit_card
    card = CreditCard.last
    assert !card.name_on_card
    assert !card.number
    assert !card.expiration
  end
  
  def test_data_is_decrypted
    test_a_credit_card
    card = CreditCard.last
    card.decrypt!
    assert card.name_on_card == valid_credit_card[:name_on_card]
    assert card.number == valid_credit_card[:number]
    assert card.expiration == valid_credit_card[:expiration]
  end
  
  def test_set_encrypted_column_name
    person = Person.new(valid_person)
    assert person.save!
    person = Person.last
    person.decrypt!
    assert person.first_name = valid_person[:first_name]
    assert person.last_name = valid_person[:last_name]
    assert person.ssn = valid_person[:ssn]
  end
  
  private
  
  def valid_credit_card
    {
      :name_on_card => 'Test User',
      :number => '1234567890123456',
      :expiration => (Date.today + 1.year).strftime("%i/%y")
    }
  end

  def valid_person
    {
      :first_name => 'Test',
      :last_name => 'User',
      :ssn => '111223333'
    }
  end

end