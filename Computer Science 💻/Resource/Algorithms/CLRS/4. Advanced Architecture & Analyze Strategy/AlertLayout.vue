<script setup lang="ts">
import { ref } from 'vue';
import { onClickOutside } from '@vueuse/core';
import TextButtonLayout from '@/common/layout/button/TextButtonLayout.vue';

const props = withDefaults(defineProps<{
  show: boolean,
  flag?: boolean
}>(), { flag: true })

const emits = defineEmits<{
  close: []
  ok: []
}>()

const onOk = () => {
  emits("ok");
}

const onClose = () => {
  emits("close");
}

const target = ref<HTMLElement | null>(null);
onClickOutside(target, () => {
  onClose();
})
</script>

<template>
  <Transition name="modal">
    <div v-if="show" class="modal">
      <div ref="target" class="modal__container">
        
        <div class="modal__header">
          <slot name="header">
            <span class="noto-sans-extrabold">알림</span>
          </slot>
        </div>

        <div class="modal__body">
          <slot name="body">default body</slot>
        </div>

        <div>
          <hr>
        </div>

        <div class="modal__footer">
          <text-button-layout class="modal__ok" :bold="true" :value="`확인`" v-if="flag" :black="true"
            @click="onOk()">
            <template #center>
              <span class="noto-sans-bold">확인</span>  
            </template>
          </text-button-layout>

          <div class="modal__divider"></div>

          <text-button-layout class="modal__cancel" :value="`취소`" @click="onClose()"></text-button-layout>
        </div>
      </div>
    </div>
  </Transition>
</template>

<style scoped lang="scss">
@use "@/common/assets/css/global" as *;

.modal {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  transition: opacity 0.3s ease;
  overflow-y: auto;
}

.modal__container {
  width: 280px;
  margin: auto;
  padding: 20px 20px;
  background-color: $white;
  border-radius: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.3s ease;
}

.modal__header {
  text-align: center;
  margin-top: 0;
  font-size: font-size(lg);
}

.modal__body {
  text-align: center;
  margin: 20px 0;
  font-size: font-size(md);
}


.modal__footer {
  display: flex;
  flex-direction: row;
  justify-content: space-around;
  padding-top: 10px;

  .modal__ok {
    width: 100%;
  }

  .modal__divider {
    width: 1px;
    height: 40px;
    background-color: $black;
  }

  .modal__cancel {
    width: 100%;
  }
}

/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter-from {
  opacity: 0;
}

.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal__container,
.modal-leave-to .modal__container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}
</style>