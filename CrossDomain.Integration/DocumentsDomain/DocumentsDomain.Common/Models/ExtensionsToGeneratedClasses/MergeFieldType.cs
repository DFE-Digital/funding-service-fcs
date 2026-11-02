namespace SFA.FCT.DocumentsDomain.Common.Models
{
    public partial class MergeFieldType
    {
        public MergeFieldType()
        {
        }

        public MergeFieldType(string name, string value)
        {
            Name = name;
            Value = value;
        }

        public override string ToString()
        {
            return string.Format($"MergeField Name:\"{Name}\" Value:\"{Value}\"");
        }

        public MergeFieldType MakeValueBold()
        {
            this.Value = Constants.BoldTextMarker + this.Value + Constants.EndOfTextMarker;
            return this;
        }

        public MergeFieldType MakeValueItalic()
        {
            this.Value = Constants.ItalicTextMarker + this.Value + Constants.EndOfTextMarker;
            return this;
        }

        public void RemoveValueIfZero()
        {
            decimal valueAsDecimal;
            if (decimal.TryParse(Value, out valueAsDecimal))
            {
                if (valueAsDecimal == decimal.Zero)
                {
                    Value = string.Empty;
                }
            }
        }
    }
}
