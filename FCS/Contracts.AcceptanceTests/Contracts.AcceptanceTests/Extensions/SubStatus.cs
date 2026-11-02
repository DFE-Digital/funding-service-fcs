namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    public class SubStatus
    {
        private readonly string _subStatusString;

        public SubStatus(string subStatusString)
        {
            _subStatusString = subStatusString;
        }

        public static implicit operator SubStatus(string subStatusString)
        {
            if (subStatusString == null)
            {
                return null;
            }
               
            return new SubStatus(subStatusString);
        }

        public string GetSanitizedString()
        {
            if (_subStatusString == "Recalculating (Held)")
            {
                return _subStatusString.Replace(" ", "_").Replace("(", string.Empty).Replace(")", string.Empty);
            }
           
            return _subStatusString.Replace(" ", string.Empty);  
        }

        public override string ToString()
        {
            return GetSanitizedString();
        }
    }
}
