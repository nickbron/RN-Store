set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.decrement_product_quantity(product_id bigint, quantity bigint)
 RETURNS void
 LANGUAGE plpgsql
AS $function$begin
update product
set "maxQuantity" = "maxQuantity" - quantity
where id = product_id and "maxQuantity" >= quantity;
end;$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
if new.raw_user_meta_data->>'avatar_url' is null or new.raw_user_meta_data->>'avatar_url' = '' then
new.raw_user_meta_data = jsonb_set(new.raw_user_meta_data,'{avatar_url}', '"https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"' :: jsonb);
end if;
insert into public.users(id, email, avatar_url)
values(new.id, new.email, new.raw_user_meta_data->>'avatar_url');
return new;
end;
$function$
;


