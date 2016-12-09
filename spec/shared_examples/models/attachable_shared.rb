require 'rails_helper'

RSpec.shared_examples 'attachable' do
#  votable_klass_symbol = described_class.to_s.underscore.to_sym

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

end