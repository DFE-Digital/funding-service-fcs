namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public static class EntityDifferenceChecker
    {
        public static bool AreThereDifferences<TModel, TSheet>(
            IReadOnlyCollection<TModel> dbRows,
            IReadOnlyCollection<TSheet> sheetRows,
            Func<TModel, TSheet, bool> isRowDifferent,
            Func<TModel, TSheet, bool> isMatch)
        {
            return sheetRows.Any(sr => isRowDifferent(dbRows.SingleOrDefault(dbRow => isMatch(dbRow, sr)), sr));
        }
    }
}