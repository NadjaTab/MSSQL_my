
declare @id int
declare @result int
    SELECT @id = 1
    SELECT @result = 0
if not exists(select * from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]')
begin  
  EXEC  @result = sp_obtain_id 'nt_l_keywords', 
  @maxid = @id OUTPUT

  insert nt_l_keywords(key_f,description_,keyword_,value_)
  values('ait'+convert(varchar(7),@id),'Êîäû íà÷èñëåíèé, âõîäÿùèå â îòïóñêíûå ñ êîıôô-òîì','[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]','')
end
go
if exists(select * from sysobjects where name='sp_replace_sum_otp')
begin
  drop procedure sp_replace_sum_otp
end 
go
create PROCEDURE sp_replace_sum_otp @p_id varchar(15), @mm1 int, @yy1 int 
AS

--declare @mm int
--declare @yy int
declare @p_main char(15)
SELECT @p_main = (select pers_id_main from const where pers_id=@p_id)

declare @ray int
SELECT @ray= (select isnull(rayon,30) from const where pers_id=@p_id)

declare @sev int
SELECT @sev= (select isnull(sever,0) from const where pers_id=@p_id)


update constn set calc_otp = (isnull(case alim when 0 then 1 else alim end, 1)*(
   select isnull(sum(summa),0) from arhiv_ras 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0' ) 
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy and (code<>'481') and (code<>'482')
   )
   +isnull(case alim when 0 then 1 else alim end, 1)*(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1' ) 
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy and (code<>'481') and (code<>'482')
   )
   +(
   select isnull(sum(summa),0) from arhiv_ras 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0') 
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy and (code<>'481') and (code<>'482')
   )
  +(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy and (code<>'481') and (code<>'482')
   ))
where pers_id_2 = @p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12* yy <= @mm1 + 12* @yy1
  and mm>0

---update constn set sotpusk = (
---   select isnull(sum(summa),0) from arhiv_ras_fond 
---    where code in (select code from sprav where otpusk='1') and (fond='960')
---    and pers_id=@p_id and mm=constn.mm and yy=constn.yy
---   )
---where pers_id = @p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12* yy <= @mm1 + 12* @yy1
---  and mm>0

update constn set sotpusk = 0
where pers_id = @p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12* yy <= @mm1 + 12* @yy1
 and mm>0

update constn set fmp_ot_r = (
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1') and (fond= '15' or code='355'  or fond= '51')
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
where pers_id = @p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12* yy <= @mm1 + 12* @yy1
  and mm>0

update constn set s1 = (isnull(case alim when 0 then 1 else alim end, 1)*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0') and (fond='1' or fond='11' or fond='21' or fond='22') 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482') 
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
   +isnull(case alim when 0 then 1 else alim end, 1)*(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1') and (fond='1' or fond='11' or fond='21' or fond='22') 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
   +(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0') and (fond='1' or fond='11' or fond='21' or fond='22') 
	and (code<>'355') and (code<>'360')  and (code<>'481') and (code<>'482')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
	+(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1') and (fond='1' or fond='11' or fond='21' or fond='22') 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   ))
where pers_id = @p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12* yy <= @mm1 + 12* @yy1
  and mm>0

update constn set s2 = (isnull(case alim when 0 then 1 else alim end, 1)*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0') and (fond='2' or fond='960' or fond='23' ) 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482') 
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
   +
	isnull(case alim when 0 then 1 else alim end, 1)*(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1') and (fond='2' or fond='960' or fond='23') 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482') 
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
   +(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0' ) and (fond='2' or fond='960' or fond='23') 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
	+(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1' ) and (fond='2' or fond='960' or fond='23') 
	and (code<>'355')and (code<>'360')  and (code<>'481') and (code<>'482')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   ))
where pers_id = @p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12* yy <= @mm1 + 12* @yy1
  and mm>0

update constn set s3 = (isnull(case alim when 0 then 1 else alim end, 1)*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0') and (fond='10' or fond='12'  or fond='25' or fond='16' ) 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482') 
    and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0 
    and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
	+isnull(case alim when 0 then 1 else alim end, 1)*(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1') and (fond='10' or fond='12'  or fond='25' or fond='16' ) 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482') 
    and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))<=0 
    and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
	+(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='0' and rayon='0' ) and (fond='10' or fond='12'  or fond='25' or fond='16' ) 
	and (code<>'355')and (code<>'360')  and (code<>'481') and (code<>'482')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
	+(100+@ray+@sev)*0.01*(
   select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1' and sever='1' and rayon='1' ) and (fond='10' or fond='12'  or fond='25' or fond='16' ) 
	and (code<>'355') and (code<>'360') and (code<>'481') and (code<>'482')
     and charindex(code,(select value_ from nt_l_keywords where keyword_='[ÊÎÄÛ_ÍÀ×_ÄËß_ÏÎÂÛØ_ÑĞÅÄ_ÇÀĞ]'))>0
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy
   )
+(  select isnull(sum(summa),0) from arhiv_ras_fond 
     where code in (select code from sprav where otpusk='1') and (code='360' or fond= '20')
     and pers_id=@p_id and mm=constn.mm and yy=constn.yy)
   


)
where pers_id = @p_id and mm + 12* yy >= @mm1 + 12* @yy1 - 12 and mm + 12* yy <= @mm1 + 12* @yy1
  and mm>0

GO
grant execute on sp_replace_sum_otp to AitUsers
go
--Â ñáîğêå çàìåíèòü pers_id íà pers_id_2!!!!!!!!
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
