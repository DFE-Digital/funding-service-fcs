namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence
{
    using System;

    /// <summary>
    /// Stub Class to generate contract number
    /// To be replaced by contract number received from CRM seed value
    /// </summary>
    public static class ContractNumberGenerator
    {
        public static string GenerateNumber()
        {
            Random rnd = new Random();
            int value = rnd.Next(100, 999);
            int decimalLength = value.ToString("D").Length + 3;
            return value.ToString("D" + decimalLength);
        }
    }
}
