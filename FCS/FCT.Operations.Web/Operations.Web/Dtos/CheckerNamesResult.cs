namespace Operations.Web.Dtos
{
    using System.Collections.Generic;

    public class CheckerNamesResult
    {
        public CheckerNamesResult(IReadOnlyCollection<string> checkerNames)
        {
            CheckerNames = checkerNames;
        }

        public IReadOnlyCollection<string> CheckerNames { get; }
    }
}