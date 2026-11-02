namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System.Collections.Generic;
    using System.Text;
    using Microsoft.Test.ObjectComparison;

    public static class ObjectComparisonMismatchExtensions
    {
        public static string WriteMismatches(this IEnumerable<ObjectComparisonMismatch> items)
        {
            StringBuilder sb = new StringBuilder();

            foreach (ObjectComparisonMismatch mismatch in items)
            {
                sb.AppendLine(string.Format(
                    "Expected {0} value: {1}, Actual {2} value: {3}, Mismatch Type: {4}",
                    mismatch.LeftObjectNode?.Name,
                    mismatch.LeftObjectNode?.ObjectValue,
                    mismatch.RightObjectNode?.Name,
                    mismatch.RightObjectNode?.ObjectValue,
                    mismatch.MismatchType));
            }

            return sb.ToString();
        }
    }
}