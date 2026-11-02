namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Utils
{
    public static class IntParseHelper
    {
        public static bool IsInteger(string toParse)
        {
            bool isNumber = false;
            int valueAsInt = 0;
            decimal intermediateValue;

            if (decimal.TryParse(toParse, out intermediateValue))
            {
                isNumber = true;
                valueAsInt = (int)intermediateValue;
            }

            bool isNoRemainder = intermediateValue - valueAsInt == 0;

            return isNumber && isNoRemainder;
        }
    }
}