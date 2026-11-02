namespace FCT.Console.Config.Synchronizers.Writers.CRM
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public abstract class CrmConfigWriter<TSheetType, TCrmEntity> where TCrmEntity : Entity
        where TSheetType : SheetTypeBase
    {
        public virtual void UpsertRowIntoCrm(TSheetType row)
        {
            TCrmEntity matchingEntity = GetRowWithMatchingKey(row);

            if (matchingEntity != null)
            {
                UpdateMatchingEntity(row, matchingEntity);
                matchingEntity.EntityState = EntityState.Changed;
                CrmHelper.GetConnection().Update(matchingEntity);
            }
            else
            {
                TCrmEntity entity = CreateEntity(row);
                CrmHelper.GetConnection().Create(entity);
            }
        }

        public void WriteToCrmDatabase(IEnumerable<TSheetType> rows, WriterBehaviour behaviour)
        {
            switch (behaviour)
            {
                case WriterBehaviour.AddOrUpdate:
                    rows.Where(r => r.PolicyStatus == PolicyStatus.Approved).ForEach(UpsertRowIntoCrm);
                    break;
                case WriterBehaviour.Delete:
                    rows.Where(r => r.PolicyStatus == PolicyStatus.Removed).ForEach(DeleteRowFromCrm);
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(behaviour), $"Unsupported WriterBehaviour: {behaviour}");
            }
        }

        protected virtual void DeleteRowFromCrm(TSheetType row)
        {
            TCrmEntity matchingEntity = GetRowWithMatchingKey(row);
            if (matchingEntity != null)
            {
                CrmHelper.GetConnection().Delete(typeof(TCrmEntity).Name, matchingEntity.Id);
            }
        }

        protected abstract void UpdateMatchingEntity(TSheetType row, TCrmEntity matchingEntity);

        protected abstract TCrmEntity CreateEntity(TSheetType row);

        protected abstract IEnumerable<TCrmEntity> GetMatchingEntities(XrmServiceContext crmContext, TSheetType row);

        protected TCrmEntity GetRowWithMatchingKey(TSheetType row)
        {
            TCrmEntity matchingRow = null;
            using (var crmContext = new XrmServiceContext(CrmHelper.GetConnection()))
            {
                var matchingEntities = GetMatchingEntities(crmContext, row).ToList();

                int numMatchingRows = matchingEntities.Count();

                if (numMatchingRows > 1)
                {
                    throw new InvalidOperationException($"There is more one than matching entity for type {typeof (TCrmEntity)}");
                }
                else if (numMatchingRows == 1)
                {
                    // we want this to blow up if there is more than one
                    matchingRow = matchingEntities.Single();
                }
            }

            return matchingRow;
        }
    }
}
