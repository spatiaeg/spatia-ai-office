import bpy,sys,os,glob
R='/home/claude/microsoft/microsoft-rocketbox/Assets/'
name,g,out=sys.argv[-3],sys.argv[-2],sys.argv[-1]
bpy.ops.wm.read_factory_settings(use_empty=True)
base=R+'Avatars/Professions/'+name
bpy.ops.import_scene.fbx(filepath=f'{base}/Export/{name}.fbx')
arm=[o for o in bpy.data.objects if o.type=='ARMATURE'][0]
for o in list(bpy.data.objects):
    if o.type=='EMPTY': bpy.data.objects.remove(o)
tex=base+'/Textures/'
for m in bpy.data.materials:
    if not m.node_tree: continue
    for n in list(m.node_tree.nodes):
        if n.type=='TEX_IMAGE' and n.image:
            fn=os.path.basename(n.image.filepath.replace('\\','/'))
            if not os.path.exists(tex+fn): m.node_tree.nodes.remove(n); continue
            img=bpy.data.images.load(tex+fn,check_existing=True)
            if 'normal' in fn: img.colorspace_settings.name='Non-Color'
            n.image=img
for img in bpy.data.images:
    if img.size[0]>1024: img.scale(1024,1024)
anims={'walk':f'xy/{g}_walk_neutral_01','sit':f'static/{g}_sit_table_idle_neutral_01','idle':f'static/{g}_idle_neutral_01'}
arm.animation_data_create()
for key,p in anims.items():
    before=set(bpy.data.objects); acts_before=set(bpy.data.actions)
    bpy.ops.import_scene.fbx(filepath=R+f'Animations/all_animations_max_motextr_{p}.max.fbx')
    new=set(bpy.data.objects)-before
    src=[o for o in new if o.type=='ARMATURE'][0]
    fr=src.animation_data.action.frame_range
    for pb in arm.pose.bones:
        if pb.name in src.pose.bones:
            c=pb.constraints.new('COPY_TRANSFORMS');c.target=src;c.subtarget=pb.name
    for o in bpy.context.view_layer.objects: o.select_set(False)
    bpy.context.view_layer.objects.active=arm;arm.select_set(True)
    bpy.ops.object.mode_set(mode='POSE');bpy.ops.pose.select_all(action='SELECT')
    bpy.ops.nla.bake(frame_start=int(fr[0]),frame_end=int(fr[1]),only_selected=True,visual_keying=True,clear_constraints=True,use_current_action=False,bake_types={'POSE'})
    bpy.ops.object.mode_set(mode='OBJECT')
    act=arm.animation_data.action;act.name=key
    slot=getattr(arm.animation_data,'action_slot',None)
    tr=arm.animation_data.nla_tracks.new();tr.name=key
    st=tr.strips.new(key,int(act.frame_range[0]),act)
    if slot is not None and hasattr(st,'action_slot'):
        try: st.action_slot=slot
        except Exception as e: print('slot err',e)
    arm.animation_data.action=None
    for o in new: bpy.data.objects.remove(o)
    for x in set(bpy.data.actions)-acts_before:
        if x is not act: bpy.data.actions.remove(x)
arm.animation_data.action=None
bpy.ops.export_scene.gltf(filepath=out,export_format='GLB',export_image_format='WEBP',export_image_quality=82,export_animation_mode='NLA_TRACKS',export_yup=True,export_apply=False)
print('DONE',out,os.path.getsize(out))
