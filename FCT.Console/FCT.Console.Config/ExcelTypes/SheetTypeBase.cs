namespace FCT.Console.Config.ExcelTypes
{
    using System;

    public abstract class SheetTypeBase
    {
        public PolicyStatus PolicyStatus { get; set; }

        public static PolicyStatus ParsePolicyStatus(string policyStatusString)
        {
            return (PolicyStatus) Enum.Parse(typeof (PolicyStatus), policyStatusString, ignoreCase: true);
        }
    }
}
