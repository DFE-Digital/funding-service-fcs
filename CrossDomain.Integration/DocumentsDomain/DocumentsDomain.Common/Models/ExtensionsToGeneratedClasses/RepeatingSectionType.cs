namespace SFA.FCT.DocumentsDomain.Common.Models
{
    using System.Linq;
    using System.Collections.Generic;

    public partial class RepeatingSectionType
    {
        public RepeatingSectionType(string name)
        {
            Name = name;
        }

        public void RemoveZerosFromFields(IReadOnlyCollection<string> fieldsToIgnore)
        {
            foreach(var row in this.Rows)
            {
                foreach(var mergeField in row.MergeFields.Where(mf => !fieldsToIgnore.Contains(mf.Name)))
                {
                    decimal value;
                    if (decimal.TryParse(mergeField.Value, out value))
                    {
                        if (value == decimal.Zero)
                        {
                            mergeField.Value = string.Empty;
                        }
                    }
                }

                row.RepeatingSection.RemoveZerosFromFields(fieldsToIgnore);
            }
        }
    }
}
