namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;
    
    public class OptionSetKey
    {
        public OptionSetKey(string optionSetName, string optionSetText)
        {
            if (string.IsNullOrEmpty(optionSetName) || string.IsNullOrEmpty(optionSetText))
            {
                throw new ArgumentException("The option set name and option set text are required");
            }

            OptionSetName = optionSetName;
            OptionSetText = optionSetText;
        }

        public string OptionSetName { get; private set; }

        public string OptionSetText { get; private set; }

        public override bool Equals(object obj)
        {
            OptionSetKey comparisonObject = obj as OptionSetKey;
            bool isEqual = false;

            if (comparisonObject != null)
            {
                isEqual = OptionSetName.Equals(comparisonObject.OptionSetName) &&
                          OptionSetText.Equals(comparisonObject.OptionSetText);
            }

            return isEqual;
        }

        public override int GetHashCode()
        {
            return OptionSetName.GetHashCode() ^ OptionSetText.GetHashCode();
        }
    }
}
