namespace FCT.Console.Config.Synchronizers.Writers.PAAS
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Linq;
    using ExcelTypes;

    public class ConfigWriter<TSheetType, TEntityType> where TSheetType : SheetTypeBase
        where TEntityType : class
    {
        private readonly DbContext _context;
        private readonly IDbSet<TEntityType> _dbSet;

        public ConfigWriter(DbContext context,
            IDbSet<TEntityType> dbSet)
        {
            _context = context;
            _dbSet = dbSet;
        }

        public void Write(IEnumerable<TSheetType> sheetConfigTypes,
            Func<IEnumerable<TSheetType>, IEnumerable<TEntityType>> transformSheetTypes,
            Func<TEntityType, object[]> getKey,
            WriterBehaviour behaviour)
        {
            Write(sheetConfigTypes, transformSheetTypes, getKey, type => true, behaviour);
        }

        public void Write(IEnumerable<TSheetType> sheetConfigTypes,
           Func<IEnumerable<TSheetType>, IEnumerable<TEntityType>> transformSheetTypes,
           Func<TEntityType, object[]> getKey, Func<TEntityType, bool> isRowIncluded,
           WriterBehaviour behaviour)
        {
            switch (behaviour)
            {
                case WriterBehaviour.AddOrUpdate:
                    var approvedRows = sheetConfigTypes.Where(so => so.PolicyStatus == PolicyStatus.Approved);
                    InsertOrUpDate(transformSheetTypes(approvedRows), getKey, isRowIncluded);
                    break;
                case WriterBehaviour.Delete:
                    var deletedRows = sheetConfigTypes.Where(so => so.PolicyStatus == PolicyStatus.Removed);
                    Delete(transformSheetTypes(deletedRows), getKey);
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(behaviour), $"Unsupported WriterBehaviour: {behaviour}");
            }
        }

        private void InsertOrUpDate(IEnumerable<TEntityType> entities, Func<TEntityType, object[]> getKey, Func<TEntityType, bool> isRowIncluded)
        {
            foreach (var entity in entities)
            {
                var existingEntity = _dbSet.Find(getKey(entity));

                if (existingEntity != null && isRowIncluded(existingEntity))
                    EntityMerger<TEntityType>.MergeNonKeyProperties(source: entity, destination: existingEntity);
                else if (existingEntity == null)
                    _dbSet.Add(entity);
            }
        }

        private void Delete<T>(IEnumerable<T> entities, Func<T, object[]> getKey) where T : class
        {
            foreach (var entity in entities)
            {
                var existingEntity = _dbSet.Find(getKey(entity));

                if (existingEntity != null)
                    _dbSet.Remove(existingEntity);
            }
        }
    }
}
