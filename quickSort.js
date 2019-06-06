function swap(arr, from, to) {
    if (from == to) return;
    var temp = arr[from];
    arr[from] = arr[to];
    arr[to] = temp;
}
  
function QuickSortWithPartition(arr, func, from, to) {
    if (!arr || !arr.length) return [];
    if (arr.length === 1) return arr;

    from = from || 0;
    to = to || arr.length - 1;
    var pivot = arr[from];
    
    var smallIndex = from;
    var bigIndex = from + 1;
    for (; bigIndex <= to; bigIndex++) {
        if (func(arr[bigIndex], pivot) < 0) {
            smallIndex++;
            swap(arr, smallIndex, bigIndex);
        }
    }
    swap(arr, smallIndex, from);
    QuickSortWithPartition(arr, func, from, smallIndex - 1);
    QuickSortWithPartition(arr, func, smallIndex + 1, to);
    return arr;
}