require 'rails_helper'

describe LocationShareValidator do
  let(:user_ids) { [1] }

  let(:validator) do
    described_class.new(
      lat: 20.0,
      lng: 20.0,
      title: 'test',
      user_ids: user_ids
    )
  end

  describe 'user_ids' do
    context 'when is empty' do
      let(:user_ids) { [] }

      it 'is invalid' do
        validator.valid?
        expect(validator.errors[:user_ids].count).to eq(1)
      end
    end

    context 'when is nil' do
      let(:user_ids) { nil }

      it 'is invalid' do
        validator.valid?
        expect(validator.errors[:user_ids].count).to eq(1)
      end
    end

    context 'when is present' do
      let(:user_ids) { [1] }

      context 'when users are friends of current user' do
        before { allow(validator).to receive(:any_friendship_exists?) { true } }

        it 'is valid' do
          validator.valid?
          expect(validator.errors[:user_ids].count).to eq(0)
        end
      end

      context 'when no users are friends of current user' do
        before { allow(validator).to receive(:any_friendship_exists?) { false } }

        it 'is invalid' do
          validator.valid?
          expect(validator.errors[:user_ids].count).to eq(1)
        end
      end
    end
  end
end
