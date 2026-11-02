namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System.Collections.Generic;
    using System.Linq;

    public class LookupCacheCriteria
    {
        public CrmLookupType LookupType { get; set; }

        public IEnumerable<object> LookupValues { get; set; }

        public override bool Equals(object obj)
        {
            LookupCacheCriteria comparisonObject = obj as LookupCacheCriteria;
            bool isEqual = false;

            if (comparisonObject != null)
            {
                if (comparisonObject.LookupType == LookupType
                    && comparisonObject.LookupValues.Count() == LookupValues.Count())
                {
                    int numMatches = 0;
                    //// now check each value matches a value on our current object
                    foreach (var value in comparisonObject.LookupValues)
                    {
                        if (LookupValues.Contains(value))
                        {
                            numMatches++;
                        }
                    }

                    isEqual = numMatches == comparisonObject.LookupValues.Count();
                }
            }

            return isEqual;
        }

        public override int GetHashCode()
        {
            int hashCode = 0;

            hashCode ^= LookupType.GetHashCode();
            foreach (var value in LookupValues)
            {
                hashCode ^= value.GetHashCode();
            }

            if (hashCode == 0)
            {
                hashCode = base.GetHashCode();
            }

            return hashCode;
        }
    }
}
