namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    public static class UopCodeTransformer
    {
        public static string ZeroPad(string uopCode)
        {
            if (uopCode != null && IsNumeric(uopCode))
            {
                return uopCode
                   .TrimStart()
                   .TrimStart('0')
                   .PadLeft(10, '0');
            }

            return uopCode;
        }

        private static bool IsNumeric(string uopCode)
        {
            int i;
            return int.TryParse(uopCode, out i);
        }
    }
}
