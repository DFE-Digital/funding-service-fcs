using System.Collections.Generic;
using System.Text;

namespace UnitTests.Common
{
    using System.Linq;
    using Microsoft.Test.ObjectComparison;

    public static class ObjectComparison
    {
        public static IReadOnlyCollection<ObjectComparisonMismatch> CompareObjects(object expectedObject, object actualObject)
        {
            IEnumerable<ObjectComparisonMismatch> mismatches;
            var factory = new PublicPropertyObjectGraphFactory();
            var comparer = new ObjectGraphComparer();

            var expectedGraph = factory.CreateObjectGraph(expectedObject);
            var actualGraph = factory.CreateObjectGraph(actualObject);

            comparer.Compare(expectedGraph, actualGraph, out mismatches);

            return mismatches.ToList();
        }

        public static string WriteMismatches(this IEnumerable<ObjectComparisonMismatch> items)
        {
            var sb = new StringBuilder();

            foreach (var mismatch in items)
            {
                sb.Append($"Expected {mismatch.LeftObjectNode?.QualifiedName} value: {mismatch.LeftObjectNode?.ObjectValue}, ");
                sb.Append($"Actual {mismatch.RightObjectNode?.QualifiedName} value: {mismatch.RightObjectNode?.ObjectValue}, ");
                sb.Append($"Mismatch Type: {mismatch.MismatchType}");
                sb.AppendLine();
            }

            return sb.ToString();
        }
    }
}
