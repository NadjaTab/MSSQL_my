if object_id('dbo.lgot_report') is not null
begin
   drop procedure dbo.lgot_report
end
go

if not exists (select * from sysobjects where id = object_id('tb_lgot_report') and OBJECTPROPERTY(id, 'IsUserTable') = 1)
create table tb_lgot_report
(id_user int NULL, key_f varchar(15) NULL, pers_id varchar(15) NULL, pf_strah_num char(15) NULL, sirname char(100) NULL, first_name char(100) NULL, father_name char(100) NULL, kod_dolsn varchar(32),dolsn char(255) NULL, d_when datetime NULL, when_ended datetime NULL, 
d_pens datetime NULL, d_r datetime NULL, lgot varchar(8) NULL,kod_pos varchar(25) NULL,stavka numeric(4,2) NULL, adres char(200) NULL, kl_ut varchar(5) NULL, num_podr int NULL, podr char(100) NULL, prim char(100) NULL,sex varchar(1) NULL)
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_lgot_report TO AitUsers
GO

if not exists (select * from sysobjects where id = object_id('tb_lgot_shtat') and OBJECTPROPERTY(id, 'IsUserTable') = 1)
create table tb_lgot_shtat
(id_user int NULL, dolsn char(255) NULL, kod_dolsn varchar(32), kolvo int NULL, lgot varchar(8) NULL,num_podr int, podr char(100) NULL, xar char(255) NULL,naim_okdtr char(255) NULL,pos_spis varchar(15) NULL, doc char(500) NULL,kut varchar(15) NULL )

GRANT SELECT, INSERT, UPDATE, DELETE ON tb_lgot_shtat TO AitUsers

GO

if not exists (select * from sysobjects where id = object_id('tb_lgot_per') and OBJECTPROPERTY(id, 'IsUserTable') = 1)
create table tb_lgot_per
(id_user int NULL, god int NULL, predpr char(100) NULL, regn varchar(15) NULL,data_n datetime NULL, prof char(100) NULL, xar char(200) NULL,naim_okdtr char(100) NULL,osn_lg varchar(10) NULL,pos_spis varchar(15) NULL,dok char(200) NULL,
kol_sht int NULL,kol_fact int NULL, kut varchar(15) NULL, pf_strah_num char(15) NULL, sirname char(100) NULL, first_name char(100) NULL, father_name char(100) NULL, dolsn char(255) NULL, d_when datetime NULL, when_ended datetime NULL, 
d_pens datetime NULL, d_r datetime NULL, lgot varchar(8) NULL,kod_pos varchar(15) NULL, adres char(200) NULL, kl_ut varchar(5) NULL, num_podr varchar(10) NULL, podr char(100) NULL, prim char(100) NULL,sex varchar(1) NULL)
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_lgot_per TO AitUsers
GO

CREATE PROCEDURE lgot_report @id_user int, @dd1 datetime, @dd2 datetime, @kf varchar(15) 
AS

--declare @id_user int, @dd1 datetime, @dd2 datetime 
--set @dd1='01/01/2017'
--set @dd2='12/31/2017'
--set @id_user=1

delete from tb_lgot_report where id_user = @id_user

--declare @p_id varchar(15)
--select @p_id = (select pers_id from pbpers4user where header_key_f = @kf)

insert into tb_lgot_report (id_user,key_f,pers_id,d_when,when_ended,lgot,kod_pos,kod_dolsn,podr) 
SELECT DISTINCT @id_user,p.key_f,p.pers_id,p.date_begin,p.date_end,d.usl_truda,d.kod_pos_spis,y.dolsn,y.n_otd 
		FROM 	 y_jur_dot y
				INNER JOIN dolsn d ON d.dolsn = y.dolsn
				INNER JOIN stag_pf p ON y.pers_id = p.pers_id
				WHERE  (p.date_begin>=@dd1 and 
				(p.date_end<=@dd2 or p.date_end IS NULL) and year(p.date_begin)<=year(@dd1)
					AND y.when_ <= p.date_end
					AND	y.when_ended >= p.date_begin)
					AND ISNULL(RTRIM(d.usl_truda) + RTRIM(d.kod_pos_spis), '') <> '' and p.condition<>''
 --WHERE date_begin>=@dd1 and (date_end<=@dd2 or date_end IS NULL) and year(date_begin)<=year(@dd1) and condition<>''

update tb_lgot_report set 
sirname=(select name from const where const.pers_id=tb_lgot_report.pers_id)

update tb_lgot_report set 
sex=(select sex from const where const.pers_id=tb_lgot_report.pers_id)

update tb_lgot_report set 
first_name=(select first_name from const where const.pers_id=tb_lgot_report.pers_id)

update tb_lgot_report set 
father_name=(select sec_name from const where const.pers_id=tb_lgot_report.pers_id)

update tb_lgot_report set
d_when=@dd1 where year(d_when)<year(@dd1)

update tb_lgot_report set
when_ended=@dd2 where when_ended IS NULL 


update tb_lgot_report set
prim=(select 'прик.'+nomer+'администр.отпуск с '+convert(varchar,date_begin,104)+' по '+convert(varchar,date_end,104) from prikaz 
where prikaz.pers_id=tb_lgot_report.pers_id and 
prikaz.date_begin=dateadd(day,1,tb_lgot_report.when_ended) and prikaz.tip='023')

update tb_lgot_report set
prim=(select 'прик.'+nomer+'простой с '+convert(varchar,date_begin,104)+' по '+convert(varchar,date_end,104) from prikaz 
where prikaz.pers_id=tb_lgot_report.pers_id and 
prikaz.date_begin=dateadd(day,1,tb_lgot_report.when_ended) and prikaz.tip='016') where prim IS NULL

update tb_lgot_report set
prim=(select 'прик.'+nomer+'донор с '+convert(varchar,date_begin,104)+' по '+convert(varchar,date_end,104) from prikaz 
where prikaz.pers_id=tb_lgot_report.pers_id and 
prikaz.date_begin=dateadd(day,1,tb_lgot_report.when_ended) and (prikaz.tip='017' or prikaz.tip='025')) where prim IS NULL

update tb_lgot_report set
prim=(select 'прик.'+nomer+'прогул с '+convert(varchar,date_begin,104)+' по '+convert(varchar,date_end,104) from prikaz 
where prikaz.pers_id=tb_lgot_report.pers_id and 
prikaz.date_begin=dateadd(day,1,tb_lgot_report.when_ended) and prikaz.tip='019') where prim IS NULL

update tb_lgot_report set
prim=(select 'прик.'+nomer+'профобучение с '+convert(varchar,date_begin,104)+' по '+convert(varchar,date_end,104) from prikaz 
where prikaz.pers_id=tb_lgot_report.pers_id and 
prikaz.date_begin=dateadd(day,1,tb_lgot_report.when_ended) and prikaz.tip='018') where prim IS NULL

update tb_lgot_report set
prim=(select 'прик.'+nomer+'уч.отпуск с '+convert(varchar,date_begin,104)+' по '+convert(varchar,date_end,104) from prikaz 
where prikaz.pers_id=tb_lgot_report.pers_id and 
prikaz.date_begin=dateadd(day,1,tb_lgot_report.when_ended) and prikaz.tip='024') where prim IS NULL
update tb_lgot_report set
prim=(select 'прик.'+nomer+'отстранение с '+convert(varchar,date_begin,104)+' по '+convert(varchar,date_end,104) from prikaz 
where prikaz.pers_id=tb_lgot_report.pers_id and 
prikaz.date_begin=dateadd(day,1,tb_lgot_report.when_ended) and prikaz.tip='028') where prim IS NULL

update tb_lgot_report set
d_r=(select date_r from const where const.pers_id=tb_lgot_report.pers_id)

update tb_lgot_report set
d_pens=dateadd(yy,60,d_r) where sex='1'

update tb_lgot_report set
d_pens=dateadd(yy,55,d_r) where sex<>'1'

--update tb_lgot_report set 
--kod_dolsn=(SELECT y.dolsn, 
--				FROM y_jur_dot y
--				INNER JOIN dolsn d ON d.dolsn = y.dolsn
--				INNER JOIN tb_lgot_report p ON y.pers_id = p.pers_id
--				WHERE  (y.when_ <= p.when_ended
--					AND	y.when_ended >= p.d_when)
--					AND ISNULL(RTRIM(d.usl_truda) + RTRIM(d.kod_pos_spis), '') <> '')
					
--update tb_lgot_report set 
--podr=(SELECT DISTINCT MAX(y.n_otd) 
--				FROM y_jur_dot y
--				INNER JOIN dolsn d ON d.dolsn = y.dolsn
--				INNER JOIN tb_lgot_report p ON y.pers_id = p.pers_id
--				WHERE  (y.when_ <= p.when_ended
--					AND	y.when_ended >= p.d_when)
--					AND ISNULL(RTRIM(d.usl_truda) + RTRIM(d.kod_pos_spis), '') <> '')					


--update tb_lgot_report set 
--kod_dolsn=y_jur_dot.dolsn from y_jur_dot where y_jur_dot.pers_id=tb_lgot_report.pers_id and 
--((y_jur_dot.when_ended<=tb_lgot_report.when_ended) or(y_jur_dot.when_<=tb_lgot_report.d_when and y_jur_dot.when_ended<=tb_lgot_report.when_ended) or (y_jur_dot.when_<=tb_lgot_report.d_when and Year(y_jur_dot.when_ended)>=year(@dd2))) 


--update tb_lgot_report set 
--kod_dolsn=(select dolsn from const where const.pers_id=tb_lgot_report.pers_id)

--update tb_lgot_report set 
--podr=(select n_otd from const where const.pers_id=tb_lgot_report.pers_id and n_otd<>'9999') 

--update tb_lgot_report set 
--kod_dolsn=y_jur_dot.dolsn,podr=y_jur_dot.n_otd from y_jur_dot where tb_lgot_report.pers_id=y_jur_dot.pers_id and (tb_lgot_report.dolsn<>y_jur_dot.dolsn or tb_lgot_report.dolsn IS NULL or tb_lgot_report.podr IS NULL)  
--and (y_jur_dot.when_<=tb_lgot_report.d_when and y_jur_dot.when_ended>=tb_lgot_report.when_ended and year(y_jur_dot.when_ended)=year(@dd2))

--update tb_lgot_report set 
--kod_dolsn=y_jur_dot.dolsn,podr=y_jur_dot.n_otd from y_jur_dot where tb_lgot_report.pers_id=y_jur_dot.pers_id and (tb_lgot_report.dolsn<>y_jur_dot.dolsn or tb_lgot_report.dolsn IS NULL or tb_lgot_report.podr IS NULL) 
--and (y_jur_dot.when_>=tb_lgot_report.d_when and y_jur_dot.when_ended>=tb_lgot_report.when_ended and year(y_jur_dot.when_ended)=year(@dd2))

--update tb_lgot_report set 
--kod_dolsn=y_jur_dot.dolsn,podr=y_jur_dot.n_otd from y_jur_dot where tb_lgot_report.pers_id=y_jur_dot.pers_id and (tb_lgot_report.dolsn<>y_jur_dot.dolsn or tb_lgot_report.dolsn IS NULL or tb_lgot_report.podr IS NULL or tb_lgot_report.podr<>y_jur_dot.n_otd) 
--and (y_jur_dot.when_ended>=tb_lgot_report.when_ended and year(y_jur_dot.when_ended)>=year(@dd2) and y_jur_dot.n_otd<>tb_lgot_report.podr)

--update tb_lgot_report set 
--kod_dolsn=y_jur_dot.dolsn,podr=y_jur_dot.n_otd from y_jur_dot where tb_lgot_report.pers_id=y_jur_dot.pers_id and (tb_lgot_report.dolsn<>y_jur_dot.dolsn or tb_lgot_report.dolsn IS NULL or tb_lgot_report.podr IS NULL) 
--and (y_jur_dot.when_ended=tb_lgot_report.when_ended and y_jur_dot.n_otd<>'9999')


update tb_lgot_report set 
kl_ut=(select 'В'+add_attr_1 from dolsn where dolsn.dolsn=tb_lgot_report.kod_dolsn and (add_attr_1<>'NULL' or add_attr_1<>''))

update tb_lgot_report set 
dolsn=dolsn.fullname_dolsn from dolsn where tb_lgot_report.kod_dolsn=dolsn.dolsn
--update tb_lgot_report set 
--dolsn= (select distinct fullname_dolsn from dolsn where dolsn.dolsn=tb_lgot_report.dolsn)

--update tb_lgot_report set 
--podr=y_jur_dot.n_otd from y_jur_dot where tb_lgot_report.pers_id=y_jur_dot.pers_id and tb_lgot_report.podr<>y_jur_dot.n_otd and year(y_jur_dot.when_)=year(@dd2)
--and ((y_jur_dot.when_<=tb_lgot_report.d_when and y_jur_dot.when_ended>=tb_lgot_report.when_ended) or (y_jur_dot.when_ended<=tb_lgot_report.when_ended))

--update tb_lgot_report set 
--podr=y_jur_dot.n_otd from y_jur_dot where tb_lgot_report.pers_id=y_jur_dot.pers_id and year(y_jur_dot.when_ended)=year(@dd2) 
--and y_jur_dot.when_ended>=tb_lgot_report.when_ended  and tb_lgot_report.podr is NULL

update tb_lgot_report set 
podr=naz_otd from xcheck where n_otd=tb_lgot_report.podr

update tb_lgot_report set 
adres=(select adress from const where const.pers_id=tb_lgot_report.pers_id)

update tb_lgot_report set 
adres=(select post_ind1 +',' from constik where constik.pers_id=tb_lgot_report.pers_id)+adres


update tb_lgot_report set 
adres=(select post_ind3 +','+ adress_pass from constik where constik.pers_id=tb_lgot_report.pers_id)
where adres IS NULL


update tb_lgot_report set 
pf_strah_num=(select left(pf_strah_num,3)+'-'+substring(pf_strah_num,4,3)+'-'+substring(pf_strah_num,7,3)+' '+substring(pf_strah_num,10,2) from const where const.pers_id=tb_lgot_report.pers_id)


delete from tb_lgot_shtat where id_user = @id_user

insert into tb_lgot_shtat(id_user,dolsn,lgot,kut,pos_spis,podr) select distinct @id_user,dolsn,lgot,kl_ut,kod_pos,podr from tb_lgot_report where id_user=@id_user order by podr 

update tb_lgot_shtat set
kolvo=(select distinct count(distinct pers_id) from tb_lgot_report where tb_lgot_report.dolsn=tb_lgot_shtat.dolsn and tb_lgot_report.podr=tb_lgot_shtat.podr)
update tb_lgot_shtat set 
xar=(select distinct add_attr_3 from dolsn where fullname_dolsn=tb_lgot_shtat.dolsn)
update tb_lgot_shtat set 
naim_okdtr=(select distinct fullname_dolsn from dolsn where fullname_dolsn=tb_lgot_shtat.dolsn)
update tb_lgot_shtat set 
doc=(select distinct add_attr_2 from dolsn where fullname_dolsn=tb_lgot_shtat.dolsn)

delete from tb_lgot_per where id_user = @id_user

declare @podr char(100)
declare @n_podr int
declare @max_n int

select @n_podr = 1
select distinct podr into #tmp_a1 from tb_lgot_shtat
select ROW_NUMBER() OVER(ORDER BY podr ASC) AS n_podr,podr into #tmp_a2 from #tmp_a1 
update tb_lgot_shtat set num_podr=#tmp_a2.n_podr from #tmp_a2 where tb_lgot_shtat.podr=#tmp_a2.podr
update tb_lgot_report set num_podr=#tmp_a2.n_podr from #tmp_a2 where tb_lgot_report.podr=#tmp_a2.podr
select @max_n = (select max(n_podr) from #tmp_a2)
while @n_podr<=@max_n
begin
	select @podr = (select podr from #tmp_a2 where n_podr=@n_podr)
	insert into tb_lgot_per(id_user,prof,xar,naim_okdtr,osn_lg,kut,pos_spis,dok,kol_sht,kol_fact,podr,num_podr) 
	select distinct @id_user,dolsn,xar,naim_okdtr,lgot,kut,pos_spis,doc,kolvo,kolvo as kol_fact,podr,num_podr from tb_lgot_shtat where id_user=@id_user and num_podr=@n_podr 
	insert into tb_lgot_per(id_user,podr,num_podr,pf_strah_num,sirname,first_name,father_name,d_pens,adres,d_r,d_when,when_ended,dolsn,lgot,kod_pos,kl_ut,prim) 
	select distinct @id_user,podr,num_podr,pf_strah_num,sirname,first_name,father_name,d_pens,adres,d_r,d_when,when_ended,dolsn,lgot,kod_pos,kl_ut,prim from tb_lgot_report where id_user=@id_user and num_podr=@n_podr order by pf_strah_num,d_when
	
	select @n_podr= @n_podr + 1
end	
--update tb_lgot_per set predpr=(select pred from ust)
update tb_lgot_per set predpr='ООО ПО ВЕКТОР'
update tb_lgot_per set regn=(select left(pf_num,3)+'-'+substring(pf_num,4,3)+'-'+substring(pf_num,7,6) from ust)
update tb_lgot_per set god=YEAR(@dd1)
 
drop table #tmp_a1
drop table #tmp_a2
 
GO

GRANT EXECUTE ON lgot_report TO AitUsers

GO
