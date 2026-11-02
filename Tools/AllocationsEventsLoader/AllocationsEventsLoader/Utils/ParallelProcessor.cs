namespace AllocationsEventsLoader.Utils
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Linq;

    public static class ParallelProcessor
    {
        public static BlockingCollection<TResult> Process<TSource, TResult>(Func<List<TSource>> getAllItems, Action<IEnumerable<TSource>, BlockingCollection<TResult>> processSlice)
        { 
            var sourceItems = getAllItems();
            int numItemsToRunInParallel = sourceItems.Count / 10;
            Console.WriteLine("{0} sourceItems items retrieved.", sourceItems.Count);
            BlockingCollection<TResult> resultItems = new BlockingCollection<TResult>();
            int beginningIndex = 0;
            IList<System.Threading.Tasks.Task> taskList = new List<System.Threading.Tasks.Task>();
            do
            {
                Console.WriteLine("Parallel processing for sourceItems {0} to {1}.",
                    beginningIndex, beginningIndex + numItemsToRunInParallel);
                var sliceOfData = sourceItems.GetRange(beginningIndex, Math.Min(numItemsToRunInParallel, sourceItems.Count - beginningIndex));
                taskList.Add(System.Threading.Tasks.Task.Run(() =>
                {
                    processSlice(sliceOfData, resultItems);
                }));
                Console.WriteLine("Completed processing items {0} to {1}.", beginningIndex, beginningIndex + numItemsToRunInParallel);

                beginningIndex += sliceOfData.Count;
            } while (beginningIndex < sourceItems.Count);

            System.Threading.Tasks.Task.WaitAll(taskList.ToArray());

            return resultItems;
        }
    }
}
