namespace SFA.FCT.CrossDomain.Integration.Common.PagedStorage
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Exceptions;
    using Framework.Logging.Interfaces;

    public class PagedStorageSeedRunner<T> : IPagedStorageSeedRunner<T>
    {
        private readonly ILogger _logger;
        private readonly IPagedStorageRepository<T> _repository;

        public PagedStorageSeedRunner(ILogger logger, IPagedStorageRepository<T> repository)
        {
            _logger = logger;
            _repository = repository;
        }

        public void Execute(IPagedStorageSeed<T> seed)
        {
            _logger.LogInformation(seed.LoggingId, "Beginning seed for {0}", typeof(T).Name);

            if (_repository.Any())
            {
                _logger.LogError(seed.LoggingId, "Repository not empty, seed will not be run");
                return;
            }

            var totalSeededEntities = 0;

            foreach (var entity in seed.GetDataEnumerable())
            {
                try
                {
                    _logger.LogInformation(
                        seed.LoggingId,
                        "Adding entity: {0} to storage",
                        seed.GetEntityString(entity));

                    _repository.Add(entity);
                    totalSeededEntities++;
                }
                catch (DuplicateKeyStorageException)
                {
                    _logger.LogError(
                        seed.LoggingId,
                        "Duplicate key storage exception storing entity: {0}",
                        seed.GetEntityString(entity));
                }
                catch (ArgumentException ex)
                {
                    _logger.LogError(
                        seed.LoggingId,
                        "Argument exception storing entity: {0}. Message: {1}",
                        seed.GetEntityString(entity),
                        ex.Message);
                }
                catch (Exception ex)
                {
                    _logger.LogError(
                        seed.LoggingId,
                        "Unexpected exception of type {0} storing entity: {1}. Message: {2}",
                        ex.GetType().Name,
                        "Argument exception storing entity: {0}. Message: {1}",
                        ex.Message);
                }
            }

            _logger.LogInformation(seed.LoggingId, "Seed ended, seeded {0} entities", totalSeededEntities);
        }

        public void ExecuteBulkReseed(IPagedStorageSeed<T> seed)
        {
            _logger.LogInformation(seed.LoggingId, $"Beginning bulk reseed for {typeof(T).Name}");

            if (_repository.Any())
            {
                _logger.LogError(seed.LoggingId, "Repository not empty, seed will not be run");
                return;
            }

            List<T> entities = seed.GetDataEnumerable().ToList();

            try
            {
                _logger.LogInformation(seed.LoggingId, $"Adding {entities.Count} entities to storage");

                _repository.Reseed(entities);
            }
            catch (Exception ex)
            {
                _logger.LogError(seed.LoggingId, $"Unexpected exception of type {ex.GetType().Name}. Message: {ex.Message}");
            }

            _logger.LogInformation(seed.LoggingId, $"Seed ended, bulk reseeded {entities.Count} entities");
        }
    }
}