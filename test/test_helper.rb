require 'rubygems'
require 'test/unit'
require 'activerecord'

ENV['RAILS_ENV'] = 'test'
require File.dirname(__FILE__) + '/../lib/acts_as_encryptable'

class Test::Unit::TestCase

  def establish_connection(db_file = nil)
    db_file = File.join(File.dirname(__FILE__), '/tmp/tests.sqlite') unless db_file      
    ActiveRecord::Base.configurations = { 'ActiveRecord::Base' => { :adapter => 'sqlite3', :database => db_file, :timeout => 5000 } }
    ActiveRecord::Base.establish_connection('ActiveRecord::Base')
    ActiveRecord::Base.connection.execute('drop table if exists credit_cards')
    ActiveRecord::Base.connection.execute('create table credit_cards (id integer, encrypted text)')
    ActiveRecord::Base.connection.execute('drop table if exists people')
    ActiveRecord::Base.connection.execute('create table people (id integer, important_data text)')
    ActiveRecord::Base.connection
  end

end