require "rails_helper"

describe Account do
  it "has a valid factory" do
    expect(create(:account)).to be_valid
  end

  describe ".associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:cash_flows) }
    it { is_expected.to belong_to :currency }
  end

  describe ".validation" do
    context "when valid" do
      subject { create(:account) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:user_id) }
      it do
        is_expected.to validate_uniqueness_of(:name).
          scoped_to([:user_id, :currency_id])
      end
      it { is_expected.to validate_presence_of :currency }
    end
  end

  it "has 0.0 funds" do
    expect(create(:account).funds).to eq(0.0)
  end

  describe "change amount" do
    let(:account) { create(:account) }

    it "have an empty account" do
      expect(account.funds).to eq(0)
    end

    it "increased amount by 100" do
      account.deposit 100
      expect(account.funds).to eq(100.0)
    end

    it "increased amount by 100 2" do
      account.deposit 100
      expect(account.reload.funds).to eq(100.0)
    end

    it "decreased amount by 100" do
      account.withdrawal 100
      expect(account.funds).to eq(-100.00)
    end

    it "not increased amount" do
      account.deposit nil
      expect(account.funds).to eq(0.0)
    end

    it "not decreased amount" do
      account.withdrawal nil
      expect(account.funds).to eq(0.0)
    end
  end
end
