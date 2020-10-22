+ 长度为n的数组，元素0-n-1，找重复的元素
  1. sort O(nlogn) O(1)
  2. 鸽笼，元素占据数组下标为当前元素的格子 O(n) O(1)
```c++
class Solution {
public:
    int findRepeatNumber(vector<int>& nums) {
        int i;
        for(i=0;i<nums.size();i++)
            if(nums[i]!=i)
                break;
        int tmp=i;
        i=nums[i];
        nums[tmp]=-1;
        while(1){
            if(i==-1){
                for(i=0;i<nums.size();i++){
                    if(nums[i]!=i)
                        break;
                }
                tmp=i;
                i=nums[i];
                nums[tmp]=-1;
            }
            else if(nums[i]==i)
                return i;
            else{
                tmp=nums[i];
                nums[i]=i;
                i=tmp;
            }
        }
        return -1;
    }
};
```
+ ## 将一个链表\ m m 位置到\ n n 位置之间的区间反转，要求时间复杂度 ，空间复杂度 。
例如：
给出的链表为 1\to 2 \to 3 \to 4 \to 5 \to NULL1→2→3→4→5→NULL, ，,
返回 1\to 4\to 3\to 2\to 5\to NULL1→4→3→2→5→NULL.
注意：
给出的 满足以下条件：
1 \leq m \leq n \leq 链表长度1≤m≤n≤链表长度

```c++
ListNode* reverseBetween(ListNode* head, int m, int n) {

      ListNode *front, *back,*nxt;
      ListNode *cur=(ListNode *)malloc(sizeof(ListNode));
      cur->next=head;
      head=cur;
      int ith=0;
      while(cur!=NULL){
          if(ith==m-1){
              front=cur;

              back=cur;
              cur=cur->next;
              for(int i=m;i<=n;i++){
                  nxt=cur->next;
                  cur->next=back;
                  back=cur;
                  cur=nxt;
              }
              front->next->next=cur;
              front->next=back;
              break;
          }
          ith++;
          cur=cur->next;
      }
      return head->next;
  }
  **
```
