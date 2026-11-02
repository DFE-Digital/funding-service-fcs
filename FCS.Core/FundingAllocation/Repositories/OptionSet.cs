namespace FundingAllocation.Repositories
{
    public class OptionSet
    {
        public OptionSet(int optionSetNumber, string optionValueLabel)
        {
            OptionSetNumber = optionSetNumber;
            OptionValueLabel = optionValueLabel;
        }

        public int OptionSetNumber { get; }

        public string OptionValueLabel { get; }
    }
}