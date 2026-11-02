namespace XrmTestModel
{
    using System;
    using System.Linq.Expressions;
    using Microsoft.Xrm.Sdk;

    public interface IUseXrmEntity<TEntity> where TEntity : Entity
    {
        TEntity Entity { get; set; }

        Guid? EntityId { get; set; }

        string EntityLogicalName { get; set; }

        IUseXrmEntity<TEntity> Get();

        IUseXrmEntity<TEntity> Get(Guid primaryKey);

        IUseXrmEntity<TEntity> Get(string primaryFieldName);

        IUseXrmEntity<TEntity> Get(Expression<Func<TEntity, bool>> predicate);
        
        void Save(object parent = null);
        
        void TranslateFromXrm(TEntity xrmEntity);

        void TranslateToXrm();

        void Delete();
    }
}