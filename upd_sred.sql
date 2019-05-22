declare @mm1 int
declare @yy1 int
declare @p_id varchar(15)
select @mm1 = 4
select @yy1=2019



DECLARE Cur1 CURSOR FOR 
select pers_id from const where n_otd<>'9999'
OPEN Cur1
FETCH NEXT FROM Cur1 into @p_id
WHILE @@FETCH_STATUS = 0
	BEGIN

		update constn set sred = (
			select isnull(sum(summa),0) from arhiv_ras
			where code in (select code from sprav where sredn='1')
			and pers_id=@p_id  and mm=constn.mm and yy=constn.yy
			)
		where pers_id=@p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12*
			yy <= @mm1 + 12* @yy1  and mm>0
  
		FETCH NEXT FROM Cur1 into @p_id
  
	END
CLOSE Cur1
DEALLOCATE Cur1
GO  
  
  
 