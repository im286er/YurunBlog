	<div id="left_nav">
		<div class="left_wrap">
			<ul class="list-group menu-list">
				<li>
					<a href="<?php echo Dispatch::url('Admin/Category/manage');?>" target="content_body"><i class="ico_category"></i>分类管理</a>
				</li>
				<li>
					<a href="javascript:;"><i class="ico_setting"></i>系统管理<i class="chevron"></i></a>
					<ul class="sub-list">
						<li><a href="javascript:;" target="content_body"><span class="item-name">用户管理</span></a></li>
					</ul>
				</li>
			</ul>
		</div>
		<div class="copyright"><?php echo Config::get('@.SYSTEM_NAME');?></div>
	</div>