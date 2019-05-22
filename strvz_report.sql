if object_id('dbo.strvz_report') is not null
begin
   drop procedure dbo.strvz_report
end
go
if not exists (select * from sysobjects where id = object_id('tb_strvz') and OBJECTPROPERTY(id, 'IsUserTable') = 1)
create table tb_strvz
(id_user int NULL, key_f varchar(15) NULL, ras_mm date NULL, pfs decimal(16,2) NULL, fss decimal(16,2) NULL, foms decimal(16,2) NULL, 
ns decimal(16,2) NULL, sp1 decimal(16,2) NULL, sp2 decimal(16,2) NULL, s131 decimal(16,2) NULL, s132 decimal(16,2) NULL,
s133 decimal(16,2) NULL, s231 decimal(16,2) NULL, s232 decimal(16,2) NULL, s233 decimal(16,2) NULL,yy int NULL,mm int NULL)
GRANT SELECT, UPDATE, INSERT, DELETE On tb_strvz To AitUsers
GO

CREATE PROCEDURE strvz_report @id_user int, @dd1 datetime, @dd2 datetime, @kf varchar(15)
AS

delete from tb_strvz 

insert into tb_strvz (id_user, key_f,yy,mm,pfs)  
select @id_user, pers_id, yy, mm, round(sum(nalog),2)
  from arhiv_social where yy=year(@dd1) and mm between month(@dd1) and month(@dd2) and code_nalog='6' and nalog<>0  
  --and pers_id in (select key_f from tb_sotr_report)
group by pers_id,yy,mm order by pers_id,yy,mm

update tb_strvz
set fss=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='2' and arhiv_social.nalog<>0 )
update tb_strvz
set foms=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='3' and arhiv_social.nalog<>0 )
update tb_strvz
set ns=(select round(sum(nalog),2) from  arhiv_travm where arhiv_travm.pers_id=tb_strvz.key_f and  arhiv_travm.yy=tb_strvz.yy and arhiv_travm.mm=tb_strvz.mm  
and arhiv_travm.nalog<>0 )
update tb_strvz
set sp1=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='8' and arhiv_social.n_stat='21' and arhiv_social.nalog<>0 )    
update tb_strvz
set s131=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='8' and arhiv_social.n_stat='31' and arhiv_social.nalog<>0 )
update tb_strvz
set s132=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='8' and arhiv_social.n_stat='32' and arhiv_social.nalog<>0 )
update tb_strvz
set s133=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='8' and arhiv_social.n_stat='33' and arhiv_social.nalog<>0 )
update tb_strvz
set sp2=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='9' and arhiv_social.n_stat='22' and arhiv_social.nalog<>0 )    
update tb_strvz
set s231=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='9' and arhiv_social.n_stat='31' and arhiv_social.nalog<>0 )
update tb_strvz
set s232=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='9' and arhiv_social.n_stat='32' and arhiv_social.nalog<>0 )
update tb_strvz
set s233=(select round(sum(nalog),2) from  arhiv_social where arhiv_social.pers_id=tb_strvz.key_f and  arhiv_social.yy=tb_strvz.yy and arhiv_social.mm=tb_strvz.mm  
and arhiv_social.code_nalog='9' and arhiv_social.n_stat='33' and arhiv_social.nalog<>0 )
update tb_strvz
set ras_mm=convert(date,'01.'+str(mm)+'.'+str(yy),104)

GRANT EXECUTE On strvz_report To AitUsers
GO

