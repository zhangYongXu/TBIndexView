# TBIndexView

      1，UITableView的索引只有另个索引方法sectionIndexTitlesForTableView和sectionForSectionIndexTitle，第一个方法返回一个String数组,
      TableView就会依次显示在索引上。第二个方法是当点击到索引的第index个索引时,跳到哪一组。实现完这两个代理方法，TableView索引的功能就做完了，
      非常简单。

      2，思考如何实现浮动View呢，首先需要找到这个原生索引视图，在这个视图上添加一个浮动View来显示当前的索引字符，通过查看UITableView的自视图数组中，
      我发现了索引名叫UITableViewIndex的东西。

      3，拿到UITableViewIndex这个索引就好好办了，我可以在这上面做很多的操作，所以我就在它上面添加了一个label来显示当前索引的字符，但是遇到另一个问题，
      那这个浮动label怎么控制显示和隐藏呢，因为当手指没有在索引上的时候或者索引结束时需要隐藏这个浮动label，但是现在我不知道什么时候索引结束，换句话说
      我我没法知道手指在索引上面的状态，于是我想到在UITableViewIndex添加点击手势和滑动Pan手势，结果勉强可以达到控制影藏显示浮动label的效果，但是效果
      不好，时而不时的实效，应为我加的收拾和UITableViewIndex本身实现的手势有冲突。

      4，鉴于往UITableViewIndex添加手势的方式不能很好的控制浮动VIew的隐藏和显示，那么我就想利用UITableViewIndex本来的手势操作，
      我打印UITableViewIndex手势数组，但是并没有发现任何实现的手势，我就想到UITableViewIndex实现的是touchesBegan，touchesMoved系列根本touches手
      势，于是解决方法有了，我知道拦截到UITableViewIndex的这几个方法就能知道手指在UITableViewIndex上的状态，从而就能正确的隐藏和显示浮动View了，
      如何拦截这几个方法就很简单了，这是runtime的黑魔法，用现成的轮子Aspect就行了，最后发现完美简单的解决了这个问题。
      
     
     
     效果：
     
     
     ![image](https://github.com/zhangYongXu/TBIndexView/blob/master/Untitled.gif)
